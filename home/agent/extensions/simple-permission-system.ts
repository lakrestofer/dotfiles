/**
 * Simple Permission System
 *
 * Intercepts tool calls and applies rules to determine if they should be:
 * - Allowed automatically
 * - Prompted for user confirmation
 * - Denied automatically
 *
 * When prompted, the user can:
 * - Allow the tool call
 * - Deny the tool call
 * - Deny with a suggestion (text input passed to the LLM)
 */

import type { ExtensionAPI, ToolCallEvent, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { execSync } from "child_process";
import { existsSync } from "fs";

// ============================================================================
// Types
// ============================================================================

/** Context passed to rule functions */
interface RuleContext {
	/** The project root / current working directory */
	projectRoot: string;
}

/** Decision returned by a rule function */
type Decision =
	| { action: "allow" }
	| { action: "prompt"; reason?: string }
	| { action: "deny"; reason?: string };

/** A rule function that evaluates a tool call and returns a decision */
type Rule = (
	toolName: string,
	params: Record<string, unknown>,
	ctx: RuleContext
) => Decision;

// ============================================================================
// Helper Functions
// ============================================================================

/**
 * Check if a path is inside a git repository
 */
function isInGitRepo(cwd: string): boolean {
	try {
		execSync(`git rev-parse --git-dir`, {
			stdio: "pipe",
			cwd,
		});
		return true;
	} catch {
		return false;
	}
}

/**
 * Check if a file is tracked by git (or doesn't exist yet, which is safe)
 */
function isGitTrackedOrNew(filePath: string, cwd: string): boolean {
	try {
		// Resolve to full path
		const fullPath = filePath.startsWith("/") ? filePath : `${cwd}/${filePath}`;

		if (!existsSync(fullPath)) {
			// New file - safe to create
			return true;
		}

		// Check if tracked by git
		execSync(`git ls-files --error-unmatch "${filePath}"`, {
			stdio: "pipe",
			cwd,
		});
		return true;
	} catch {
		return false;
	}
}

// ============================================================================
// Rules
// ============================================================================

/**
 * Block any bash command containing "sudo"
 */
const blockSudo: Rule = (toolName, params, _ctx) => {
	if (toolName !== "bash") return { action: "allow" };

	const command = params.command;
	if (typeof command === "string" && /\bsudo\b/.test(command)) {
		return { action: "deny", reason: "Commands with sudo are blocked" };
	}

	return { action: "allow" };
};

/**
 * Block any operations on .env files to protect secrets
 */
const blockEnvFiles: Rule = (toolName, params, _ctx) => {
	// Check path-based tools
	const pathTools = ["read", "write", "edit"];
	if (pathTools.includes(toolName)) {
		const path = params.path;
		if (typeof path === "string" && /\.env($|\.)/.test(path)) {
			return { action: "deny", reason: "Operations on .env files are blocked to protect secrets" };
		}
	}

	// Check bash commands that might touch .env files
	if (toolName === "bash") {
		const command = params.command;
		if (typeof command === "string" && /\.env($|\.|\s)/.test(command)) {
			return { action: "deny", reason: "Bash commands referencing .env files are blocked" };
		}
	}

	return { action: "allow" };
};

/**
 * Prompt for confirmation before any rm command
 */
const promptBeforeRm: Rule = (toolName, params, _ctx) => {
	if (toolName !== "bash") return { action: "allow" };

	const command = params.command;
	if (typeof command !== "string") return { action: "allow" };

	// Match rm command (standalone or in a pipeline/chain)
	if (/\brm\s/.test(command)) {
		// Extra warning for recursive/force flags
		const isRecursive = /\brm\s+(-[a-zA-Z]*r|--recursive)/.test(command);
		const isForced = /\brm\s+(-[a-zA-Z]*f|--force)/.test(command);

		let reason = "rm command detected";
		if (isRecursive && isForced) {
			reason = "⚠️  DANGEROUS: rm with recursive AND force flags";
		} else if (isRecursive) {
			reason = "⚠️  rm with recursive flag";
		} else if (isForced) {
			reason = "⚠️  rm with force flag";
		}

		return { action: "prompt", reason };
	}

	return { action: "allow" };
};

/**
 * Prompt before destructive operations on files not under version control
 */
const promptUnversionedDestructive: Rule = (toolName, params, ctx) => {
	// Handle write/edit tools
	if (toolName === "write" || toolName === "edit") {
		const path = params.path;
		if (typeof path !== "string") return { action: "allow" };

		// Resolve to full path for checking
		const fullPath = path.startsWith("/") ? path : `${ctx.projectRoot}/${path}`;

		// If not in a git repo at all, prompt
		if (!isInGitRepo(ctx.projectRoot)) {
			// Only prompt if file already exists (new files are fine)
			if (existsSync(fullPath)) {
				return {
					action: "prompt",
					reason: `Not in a git repo - "${path}" cannot be reverted`,
				};
			}
		} else {
			// If file exists but is not tracked, prompt
			if (!isGitTrackedOrNew(path, ctx.projectRoot)) {
				return {
					action: "prompt",
					reason: `File "${path}" is not tracked by git - changes cannot be reverted`,
				};
			}
		}
	}

	// Handle bash commands
	if (toolName === "bash") {
		const command = params.command;
		if (typeof command !== "string") return { action: "allow" };

		// Patterns for destructive bash operations
		const destructivePatterns = [
			/\brm\s/,           // rm command
			/\bmv\s/,           // mv command (can overwrite)
			/>\s*[^\s]/,        // redirect overwrite (not >>)
			/\btruncate\s/,     // truncate command
			/\bshred\s/,        // shred command
			/\bdd\s.*\bof=/,    // dd with output file
		];

		const isDestructive = destructivePatterns.some((p) => p.test(command));
		if (!isDestructive) return { action: "allow" };

		// If not in a git repo, prompt for any destructive command
		if (!isInGitRepo(ctx.projectRoot)) {
			return {
				action: "prompt",
				reason: `Destructive command outside git repo - cannot revert`,
			};
		}

		// For destructive bash commands in a git repo, we still want to be careful
		// The rm rule handles rm specifically, so skip it here to avoid double-prompting
		if (!/\brm\s/.test(command)) {
			return {
				action: "prompt",
				reason: `Destructive bash command - verify target is under version control`,
			};
		}
	}

	return { action: "allow" };
};

/**
 * Prompt for confirmation when accessing files outside the project
 */
const promptOutsideProject: Rule = (toolName, params, ctx) => {
	// Tools that have a path parameter
	const pathTools = ["read", "write", "edit"];
	if (!pathTools.includes(toolName)) return { action: "allow" };

	const path = params.path;
	if (typeof path !== "string") return { action: "allow" };

	// Resolve path relative to project root
	const isAbsolute = path.startsWith("/");
	const normalizedPath = isAbsolute ? path : `${ctx.projectRoot}/${path}`;

	// Check if path is outside project root
	if (!normalizedPath.startsWith(ctx.projectRoot)) {
		return {
			action: "prompt",
			reason: `File "${path}" is outside the project directory`,
		};
	}

	return { action: "allow" };
};

/**
 * Block commands that could exfiltrate data
 */
const blockExfiltration: Rule = (toolName, params, _ctx) => {
	if (toolName !== "bash") return { action: "allow" };

	const command = params.command;
	if (typeof command !== "string") return { action: "allow" };

	// Patterns that could send data externally
	const exfilPatterns = [
		/\bcurl\s.*(-d|--data|-F|--form|POST)/i,  // curl POST/data
		/\bcurl\s.*-X\s*(POST|PUT|PATCH)/i,       // curl with explicit method
		/\bwget\s.*--post/i,                       // wget POST
		/\bnc\s/,                                   // netcat
		/\bncat\s/,                                 // ncat
		/\bscp\s/,                                  // scp
		/\brsync\s.*:/,                             // rsync to remote
		/\bsftp\s/,                                 // sftp
	];

	if (exfilPatterns.some((p) => p.test(command))) {
		return { action: "prompt", reason: "Command may send data externally" };
	}

	return { action: "allow" };
};

/**
 * Block modifications to system paths
 */
const blockSystemChanges: Rule = (toolName, params, ctx) => {
	const systemPaths = ["/etc", "/usr", "/var", "/boot", "/sys", "/proc", "/lib", "/lib64", "/sbin", "/bin"];

	if (toolName === "write" || toolName === "edit") {
		const path = params.path;
		if (typeof path === "string") {
			const fullPath = path.startsWith("/") ? path : `${ctx.projectRoot}/${path}`;
			if (systemPaths.some((sp) => fullPath.startsWith(sp + "/"))) {
				return { action: "deny", reason: `Modifying system path "${path}" is blocked` };
			}
		}
	}

	// Also block bash commands that write to system paths
	if (toolName === "bash") {
		const command = params.command;
		if (typeof command === "string") {
			// Check for redirects or writes to system paths
			for (const sp of systemPaths) {
				if (new RegExp(`>\\s*${sp}/`).test(command)) {
					return { action: "deny", reason: `Writing to system path "${sp}" is blocked` };
				}
			}
		}
	}

	return { action: "allow" };
};

/**
 * Global list of rules to apply to each tool call.
 * Rules are evaluated in order; the most restrictive decision wins.
 * Order: deny rules first, then prompt rules, then allow.
 */
const RULES: Rule[] = [
	// Deny rules (most restrictive)
	blockSudo,
	blockEnvFiles,
	blockSystemChanges,
	// Prompt rules
	promptBeforeRm,
	promptUnversionedDestructive,
	promptOutsideProject,
	blockExfiltration,
];

// ============================================================================
// Rule Evaluation
// ============================================================================

/** Priority of each action (higher = more restrictive) */
const ACTION_PRIORITY: Record<Decision["action"], number> = {
	allow: 0,
	prompt: 1,
	deny: 2,
};

/**
 * Evaluate all rules and return the most restrictive decision.
 * deny > prompt > allow
 */
function evaluateRules(
	toolName: string,
	params: Record<string, unknown>,
	ctx: RuleContext
): Decision {
	let result: Decision = { action: "allow" };

	for (const rule of RULES) {
		const decision = rule(toolName, params, ctx);

		if (ACTION_PRIORITY[decision.action] > ACTION_PRIORITY[result.action]) {
			result = decision;
		}

		// Short-circuit: deny is the most restrictive
		if (result.action === "deny") {
			break;
		}
	}

	return result;
}

// ============================================================================
// Extension
// ============================================================================

export default function(pi: ExtensionAPI) {
	pi.on("tool_call", async (event: ToolCallEvent, ctx: ExtensionContext) => {
		const ruleCtx: RuleContext = {
			projectRoot: ctx.cwd,
		};

		const decision = evaluateRules(event.toolName, event.input, ruleCtx);

		// Auto-allow
		if (decision.action === "allow") {
			return;
		}

		// Auto-deny
		if (decision.action === "deny") {
			return {
				block: true,
				reason: decision.reason ?? "Blocked by rule",
			};
		}

		// Prompt user for confirmation
		if (decision.action === "prompt") {
			if (!ctx.hasUI) {
				// No UI available, default to blocking
				return {
					block: true,
					reason: decision.reason ?? "Blocked (no UI for confirmation)",
				};
			}

			// Format the tool call for display
			const toolDisplay = formatToolCall(event.toolName, event.input);
			const reasonText = decision.reason ? `\n${decision.reason}` : "";
			const title = `Tool: ${event.toolName}${reasonText}\n\n${toolDisplay}`;

			const choice = await ctx.ui.select(title, [
				"Allow",
				"Deny",
				"Deny with suggestion",
			]);

			if (choice === "Allow" || choice === undefined) {
				// User allowed or dismissed (ESC) - proceed with tool call
				return;
			}

			if (choice === "Deny") {
				return {
					block: true,
					reason: decision.reason ?? "Denied by user",
				};
			}

			if (choice === "Deny with suggestion") {
				const suggestion = await ctx.ui.input(
					"Suggestion for the LLM:",
					"e.g., Try a different approach..."
				);

				const reason = suggestion
					? `Denied by user. Suggestion: ${suggestion}`
					: decision.reason ?? "Denied by user";

				return {
					block: true,
					reason,
				};
			}
		}
	});
}

// ============================================================================
// Helpers
// ============================================================================

/**
 * Format a tool call for display in the confirmation dialog.
 */
function formatToolCall(toolName: string, params: Record<string, unknown>): string {
	const lines: string[] = [];

	for (const [key, value] of Object.entries(params)) {
		if (value === undefined || value === null) continue;

		let valueStr = String(value);
		// Truncate long values
		if (valueStr.length > 100) {
			valueStr = valueStr.slice(0, 100) + "...";
		}
		// Handle multi-line values
		if (valueStr.includes("\n")) {
			const firstLine = valueStr.split("\n")[0];
			valueStr = firstLine.slice(0, 80) + "... (multi-line)";
		}

		lines.push(`  ${key}: ${valueStr}`);
	}

	return lines.join("\n");
}
