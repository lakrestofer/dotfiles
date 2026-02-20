/**
 * Intercept pip/python commands Extension
 *
 * Blocks direct `pip`, `pip3`, `python`, and `python3` commands in bash tool calls,
 * advising the agent to use `uv` instead.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

const BLOCKED_COMMANDS = ["pip", "pip3", "python", "python3"];

/**
 * Check if a bash command starts with or pipes into a blocked command.
 * Matches patterns like:
 *   pip install foo
 *   python script.py
 *   sudo pip install foo
 *   /usr/bin/python3 script.py
 */
function findBlockedCommand(command: string): string | undefined {
	// Normalize: trim, collapse whitespace
	const trimmed = command.trim();

	// Split on shell operators to check each sub-command
	// Handles: cmd1 && cmd2, cmd1 || cmd2, cmd1 | cmd2, cmd1; cmd2
	const subCommands = trimmed.split(/\s*(?:&&|\|\||[|;])\s*/);

	for (const sub of subCommands) {
		const parts = sub.trim().split(/\s+/);

		// Skip sudo/env prefixes
		let i = 0;
		while (i < parts.length && (parts[i] === "sudo" || parts[i] === "env")) {
			i++;
		}
		// Skip env VAR=val pairs
		while (i < parts.length && /^[A-Z_]+=/.test(parts[i])) {
			i++;
		}

		if (i >= parts.length) continue;

		// Get the actual command, stripping any path prefix
		const cmd = parts[i].replace(/^.*\//, "");

		if (BLOCKED_COMMANDS.includes(cmd)) {
			return cmd;
		}
	}

	return undefined;
}

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, _ctx) => {
		if (!isToolCallEventType("bash", event)) return;

		const blocked = findBlockedCommand(event.input.command);
		if (blocked) {
			const alternatives =
				blocked === "pip" || blocked === "pip3"
					? "Use `uv add` to add dependencies, or `uv pip install` if you must use pip semantics."
					: "Use `uv run script.py` to run Python scripts, or `uv run --with <pkg> script.py` for ad-hoc dependencies.";

			return {
				block: true,
				reason: `Direct \`${blocked}\` usage is not allowed. ${alternatives} See the \`uv\` skill for more details.`,
			};
		}
	});
}
