import { existsSync } from "node:fs";
import { Rule } from "./index.js";
import { execSync } from "child_process";

// utils

/**
 * Check if a path is inside a git repository
 */
export function isInGitRepo(cwd: string): boolean {
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
export function isGitTrackedOrNew(filePath: string, cwd: string): boolean {
  try {
    const fullPath = filePath.startsWith("/") ? filePath : `${cwd}/${filePath}`;

    if (!existsSync(fullPath)) {
      return true;
    }

    execSync(`git ls-files --error-unmatch "${filePath}"`, {
      stdio: "pipe",
      cwd,
    });
    return true;
  } catch {
    return false;
  }
}



/**
 * Prompt before destructive operations on files not under version control
 */
export const promptUnversionedDestructive: Rule = (toolName, params, ctx) => {
  if (toolName === "write" || toolName === "edit") {
    const path = params.path;
    if (typeof path !== "string") return { action: "allow" };

    const fullPath = path.startsWith("/") ? path : `${ctx.projectRoot}/${path}`;

    if (!isInGitRepo(ctx.projectRoot)) {
      if (existsSync(fullPath)) {
        return {
          action: "prompt",
          reason: `Not in a git repo - "${path}" cannot be reverted`,
        };
      }
    } else {
      if (!isGitTrackedOrNew(path, ctx.projectRoot)) {
        return {
          action: "prompt",
          reason: `File "${path}" is not tracked by git - changes cannot be reverted`,
        };
      }
    }
  }

  return { action: "allow" };
};
