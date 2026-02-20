import { parse } from "../../lib/sh/src/parse.js";
import { Rule } from "./index.js";
import { walkCommands, wordToString } from "./util.js";

/**
 * Block modifications to system paths
 */
export const blockSystemChanges: Rule = (toolName, params, ctx) => {
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

  // For bash, use AST to check redirect targets to system paths
  if (toolName === "bash") {
    const command = params.command;
    if (typeof command !== "string") return { action: "allow" };

    try {
      const { ast } = parse(command);
      let blocked: string | undefined;
      walkCommands(ast, (cmd) => {
        for (const redir of cmd.redirects ?? []) {
          if (redir.op === ">" || redir.op === ">>" || redir.op === ">|") {
            const target = wordToString(redir.target);
            for (const sp of systemPaths) {
              if (target.startsWith(sp + "/")) {
                blocked = sp;
                return true;
              }
            }
          }
        }
        return false;
      });
      if (blocked) {
        return { action: "deny", reason: `Writing to system path "${blocked}" is blocked` };
      }
    } catch {
      // Fallback to regex
      for (const sp of systemPaths) {
        if (new RegExp(`>\\s*${sp}/`).test(command)) {
          return { action: "deny", reason: `Writing to system path "${sp}" is blocked` };
        }
      }
    }
  }

  return { action: "allow" };
};
