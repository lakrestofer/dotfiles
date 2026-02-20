import { Rule } from "./index.js";
import { parse } from "../../lib/sh/src/index.js";
import { walkCommands, wordToString } from "./util.js";


// ============================================================================
// Shell AST Utilities (adapted from guardrails extension)
// ============================================================================

// ============================================================================
// Pattern Definitions
// ============================================================================

/**
 * Structural matcher: checks parsed command words (the actual command and its
 * arguments, free from quoting artifacts). Returns a description if matched.
 */
type StructuralMatcher = (words: string[]) => string | undefined;

/**
 * Fallback pattern for when AST parsing fails.
 * Used for substring matching against the raw command string.
 */
interface FallbackPattern {
  pattern: string;
  regex?: boolean;
  description: string;
  action: "deny" | "prompt";
}

// ---------------------------------------------------------------------------
// Structural matchers — checked against the parsed AST
// These won't false-positive on e.g. `git commit -m "don't use sudo"`
// ---------------------------------------------------------------------------

const DENY_MATCHERS: StructuralMatcher[] = [
  // sudo
  (words) => (words[0] === "sudo" ? "Commands with sudo are blocked" : undefined),
];

const PROMPT_MATCHERS: StructuralMatcher[] = [
  // rm (any variant)
  (words) => {
    if (words[0] !== "rm") return undefined;
    const hasRecursive = words.some(
      (w) => w === "-r" || w === "-R" || (w.startsWith("-") && w.includes("r")),
    );
    const hasForce = words.some(
      (w) => w === "-f" || (w.startsWith("-") && w.includes("f")),
    );
    if (hasRecursive && hasForce) return "⚠️  DANGEROUS: rm with recursive AND force flags";
    if (hasRecursive) return "⚠️  rm with recursive flag";
    if (hasForce) return "⚠️  rm with force flag";
    return "rm command detected";
  },

  // mv (can overwrite files)
  (words) => (words[0] === "mv" ? "mv command detected" : undefined),

  // truncate / shred
  (words) => (words[0] === "truncate" ? "truncate command detected" : undefined),
  (words) => (words[0] === "shred" ? "shred command detected" : undefined),

  // dd with output file
  (words) => {
    if (words[0] !== "dd") return undefined;
    return words.some((w) => w.startsWith("of=")) ? "dd with output file" : undefined;
  },

  // mkfs.*
  (words) => (words[0]?.startsWith("mkfs.") ? "filesystem format command" : undefined),

  // chmod -R 777
  (words) => {
    if (words[0] !== "chmod") return undefined;
    return words.includes("-R") && words.includes("777")
      ? "insecure recursive permissions"
      : undefined;
  },

  // chown -R
  (words) => {
    if (words[0] !== "chown") return undefined;
    return words.includes("-R") ? "recursive ownership change" : undefined;
  },

  // Data exfiltration: curl POST
  (words) => {
    if (words[0] !== "curl") return undefined;
    const hasPost = words.some(
      (w) =>
        w === "-d" || w === "--data" ||
        w === "-F" || w === "--form" ||
        w === "POST" || w === "PUT" || w === "PATCH",
    );
    const hasMethod = words.some(
      (w, i) =>
        (words[i - 1] === "-X") &&
        ["POST", "PUT", "PATCH"].includes(w.toUpperCase()),
    );
    return (hasPost || hasMethod) ? "Command may send data externally (curl)" : undefined;
  },

  // Data exfiltration: wget POST
  (words) => {
    if (words[0] !== "wget") return undefined;
    return words.some((w) => w.startsWith("--post"))
      ? "Command may send data externally (wget)"
      : undefined;
  },

  // Netcat / ncat / scp / sftp
  (words) => {
    const exfilCmds: Record<string, string> = {
      nc: "netcat", ncat: "ncat", scp: "scp", sftp: "sftp",
    };
    const desc = exfilCmds[words[0] ?? ""];
    return desc ? `Command may send data externally (${desc})` : undefined;
  },

  // rsync to remote (contains ":")
  (words) => {
    if (words[0] !== "rsync") return undefined;
    return words.some((w) => !w.startsWith("-") && w.includes(":"))
      ? "Command may send data externally (rsync to remote)"
      : undefined;
  },
];

// ---------------------------------------------------------------------------
// Fallback patterns — substring/regex matching on raw command string
// Only used when AST parsing fails (e.g. incomplete/invalid shell syntax)
// ---------------------------------------------------------------------------

const FALLBACK_PATTERNS: FallbackPattern[] = [
  // Deny
  { pattern: "\\bsudo\\b", regex: true, description: "Commands with sudo are blocked", action: "deny" },
  // Prompt
  { pattern: "\\brm\\s", regex: true, description: "rm command detected", action: "prompt" },
  { pattern: "\\bmv\\s", regex: true, description: "mv command detected", action: "prompt" },
  { pattern: "\\btruncate\\s", regex: true, description: "truncate command detected", action: "prompt" },
  { pattern: "\\bshred\\s", regex: true, description: "shred command detected", action: "prompt" },
  { pattern: "\\bdd\\s", regex: true, description: "dd command detected", action: "prompt" },
  { pattern: "mkfs.", description: "filesystem format command", action: "prompt" },
  { pattern: "\\bcurl\\s.*(-d|--data|-F|--form|POST)", regex: true, description: "curl POST", action: "prompt" },
  { pattern: "\\bwget\\s.*--post", regex: true, description: "wget POST", action: "prompt" },
  { pattern: "\\bnc\\s", regex: true, description: "netcat", action: "prompt" },
  { pattern: "\\bncat\\s", regex: true, description: "ncat", action: "prompt" },
  { pattern: "\\bscp\\s", regex: true, description: "scp", action: "prompt" },
  { pattern: "\\bsftp\\s", regex: true, description: "sftp", action: "prompt" },
  { pattern: "\\brsync\\s.*:", regex: true, description: "rsync to remote", action: "prompt" },
];

// ---------------------------------------------------------------------------
// Allow patterns — commands that bypass all checks (substring on raw string)
// ---------------------------------------------------------------------------

const ALLOWED_PATTERNS: string[] = [
  // Add patterns here for commands that should never be blocked, e.g.:
  // "rm -rf node_modules",
  // "rm -rf dist",
];

// ============================================================================
// AST-based Shell Command Checking
// ============================================================================

interface ShellMatch {
  action: "deny" | "prompt";
  description: string;
}

/**
 * Check a parsed command's words against structural matchers.
 */
function checkStructuralDeny(words: string[]): string | undefined {
  if (words.length === 0) return undefined;
  for (const matcher of DENY_MATCHERS) {
    const desc = matcher(words);
    if (desc) return desc;
  }
  return undefined;
}

function checkStructuralPrompt(words: string[]): string | undefined {
  if (words.length === 0) return undefined;
  for (const matcher of PROMPT_MATCHERS) {
    const desc = matcher(words);
    if (desc) return desc;
  }
  return undefined;
}

/**
 * Test a fallback pattern against a raw command string.
 */
function testFallbackPattern(fp: FallbackPattern, command: string): boolean {
  if (fp.regex) {
    try {
      return new RegExp(fp.pattern).test(command);
    } catch {
      return false;
    }
  }
  return command.includes(fp.pattern);
}

/**
 * Check a shell command for dangerous patterns.
 *
 * 1. Try AST parsing for accurate structural matching.
 * 2. If parsing fails, fall back to substring/regex on raw string.
 */
export function checkShellCommand(command: string): ShellMatch | undefined {
  // Check allow-list first
  for (const pattern of ALLOWED_PATTERNS) {
    if (command.includes(pattern)) return undefined;
  }

  // Try structural matching via AST
  try {
    const { ast } = parse(command);
    let match: ShellMatch | undefined;

    // Check deny matchers first (most restrictive)
    walkCommands(ast, (cmd) => {
      const words = (cmd.words ?? []).map(wordToString);
      const desc = checkStructuralDeny(words);
      if (desc) {
        match = { action: "deny", description: desc };
        return true; // stop walking
      }
      return false;
    });
    if (match) return match;

    // Check prompt matchers
    walkCommands(ast, (cmd) => {
      const words = (cmd.words ?? []).map(wordToString);
      const desc = checkStructuralPrompt(words);
      if (desc) {
        match = { action: "prompt", description: desc };
        return true;
      }
      return false;
    });

    // Structural matching succeeded — return result (even if no match).
    // Do NOT fall through to fallback patterns which would false-positive
    // on patterns inside quoted arguments.
    return match;
  } catch {
    // Parse failed — fall back to substring/regex matching
    for (const fp of FALLBACK_PATTERNS) {
      if (testFallbackPattern(fp, command)) {
        return { action: fp.action, description: fp.description };
      }
    }
  }

  return undefined;
}



// ============================================================================
// Rules
// ============================================================================
/**
 * Check shell commands against structural matchers + fallback patterns.
 * This single rule replaces the old blockSudo, promptBeforeRm,
 * blockExfiltration rules with AST-accurate matching.
 */
export const checkShellPatterns: Rule = (toolName, params, _ctx) => {
  if (toolName !== "bash") return { action: "allow" };

  const command = params.command;
  if (typeof command !== "string") return { action: "allow" };

  const match = checkShellCommand(command);
  if (!match) return { action: "allow" };

  return { action: match.action, reason: match.description };
};
