import { Rule } from "./index.js";

/**
 * Prompt for confirmation when accessing files outside the project
 */
export const promptOutsideProject: Rule = (toolName, params, ctx) => {
	const pathTools = ["read", "write", "edit"];
	if (!pathTools.includes(toolName)) return { action: "allow" };

	const path = params.path;
	if (typeof path !== "string") return { action: "allow" };

	const isAbsolute = path.startsWith("/");
	const normalizedPath = isAbsolute ? path : `${ctx.projectRoot}/${path}`;

	if (!normalizedPath.startsWith(ctx.projectRoot)) {
		return {
			action: "prompt",
			reason: `File "${path}" is outside the project directory`,
		};
	}

	return { action: "allow" };
};
