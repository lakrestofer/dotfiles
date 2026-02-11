/**
 * Tool Gate Extension
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
// Rules
// ============================================================================

/**
 * Example rule: Block any bash command containing "sudo"
 */
const blockSudo: Rule = (toolName, params, _ctx) => {
	if (toolName !== "bash") return { action: "allow" };

	const command = params.command;
	if (typeof command === "string" && command.includes("sudo")) {
		return { action: "deny", reason: "Commands with sudo are blocked" };
	}

	return { action: "allow" };
};

/**
 * Example rule: Prompt for confirmation when accessing files outside the project
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
 * Global list of rules to apply to each tool call.
 * Add your custom rules here.
 */
const RULES: Rule[] = [
	blockSudo,
	promptOutsideProject,
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

export default function (pi: ExtensionAPI) {
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
