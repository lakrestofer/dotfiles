import { parse } from "../../lib/sh/src/parse.js";
import { Rule } from "./index.js";
import { walkCommands, wordToString } from "./util.js";

/**
 * Block any operations on .env files to protect secrets
 */
export const blockEnvFiles: Rule = (toolName, params, _ctx) => {
  const pathTools = ["read", "write", "edit"];
  if (pathTools.includes(toolName)) {
    const path = params.path;
    if (typeof path === "string" && /\.env($|\.)/.test(path)) {
      return { action: "deny", reason: "Operations on .env files are blocked to protect secrets" };
    }
  }

  // For bash commands, use AST to check arguments for .env references
  if (toolName === "bash") {
    const command = params.command;
    if (typeof command !== "string") return { action: "allow" };

    try {
      const { ast } = parse(command);
      let found = false;
      walkCommands(ast, (cmd) => {
        const words = (cmd.words ?? []).map(wordToString);
        // Check all arguments (not just the command name) for .env patterns
        for (const word of words) {
          if (/\.env($|\.)/.test(word)) {
            found = true;
            return true;
          }
        }
        // Also check redirect targets
        for (const redir of cmd.redirects ?? []) {
          if (/\.env($|\.)/.test(wordToString(redir.target))) {
            found = true;
            return true;
          }
        }
        return false;
      });
      if (found) {
        return { action: "deny", reason: "Bash commands referencing .env files are blocked" };
      }
    } catch {
      // Fallback to regex on raw string
      if (/\.env($|\.|\s)/.test(command)) {
        return { action: "deny", reason: "Bash commands referencing .env files are blocked" };
      }
    }
  }

  return { action: "allow" };
};
