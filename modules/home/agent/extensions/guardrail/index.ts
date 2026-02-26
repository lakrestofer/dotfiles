/**
 * Guardrail
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
 *
 * Shell commands are parsed into an AST for accurate structural matching,
 * with fallback to substring/regex matching if parsing fails.
 */

import type { ExtensionAPI, ToolCallEvent, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { blockSystemChanges } from "./blockSystemChanges.js";
import { promptOutsideProject } from "./promptOutsideProject.js";
import { promptUnversionedDestructive } from "./promptUnversionedDestructive.js";
import { checkShellPatterns } from "./checkShellPatterns.js";
import { blockEnvFiles } from "./blockEnvFiles.js";
import { formatToolCall } from "./util.js";

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
export type Rule = (
	toolName: string,
	params: Record<string, unknown>,
	ctx: RuleContext
) => Decision;


/**
 * Global list of rules to apply to each tool call.
 * Rules are evaluated in order; the most restrictive decision wins.
 */
const RULES: Rule[] = [
	// Deny rules (most restrictive)
	blockEnvFiles,
	blockSystemChanges,
	// Shell command patterns (deny + prompt, AST-based)
	checkShellPatterns,
	// Prompt rules
	promptUnversionedDestructive,
	promptOutsideProject,
];

// ============================================================================
// Rule Evaluation
// ============================================================================

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
	// pi.on("tool_call", async (event: ToolCallEvent, ctx: ExtensionContext) => {
	// 	const ruleCtx: RuleContext = {
	// 		projectRoot: ctx.cwd,
	// 	};

	// 	const decision = evaluateRules(event.toolName, event.input, ruleCtx);

	// 	if (decision.action === "allow") {
	// 		return;
	// 	}

	// 	if (decision.action === "deny") {
	// 		return {
	// 			block: true,
	// 			reason: decision.reason ?? "Blocked by rule",
	// 		};
	// 	}

	// 	if (decision.action === "prompt") {
	// 		if (!ctx.hasUI) {
	// 			return {
	// 				block: true,
	// 				reason: decision.reason ?? "Blocked (no UI for confirmation)",
	// 			};
	// 		}

	// 		const toolDisplay = formatToolCall(event.toolName, event.input);
	// 		const reasonText = decision.reason ? `\n${decision.reason}` : "";
	// 		const title = `Tool: ${event.toolName}${reasonText}\n\n${toolDisplay}`;

	// 		const choice = await ctx.ui.select(title, [
	// 			"Allow",
	// 			"Deny",
	// 			"Deny with suggestion",
	// 		]);

	// 		if (choice === "Allow" || choice === undefined) {
	// 			return;
	// 		}

	// 		if (choice === "Deny") {
	// 			return {
	// 				block: true,
	// 				reason: decision.reason ?? "Denied by user",
	// 			};
	// 		}

	// 		if (choice === "Deny with suggestion") {
	// 			const suggestion = await ctx.ui.input(
	// 				"Suggestion for the LLM:",
	// 				"e.g., Try a different approach..."
	// 			);

	// 			const reason = suggestion
	// 				? `Denied by user. Suggestion: ${suggestion}`
	// 				: decision.reason ?? "Denied by user";

	// 			return {
	// 				block: true,
	// 				reason,
	// 			};
	// 		}
	// 	}
	// });
}

