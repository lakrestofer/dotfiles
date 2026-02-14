/**
 * Shared todo types and utilities used by both:
 * - plan-mode extension (ephemeral plan step tracking)
 * - todos extension (persistent file-based todos)
 *
 * This module provides common interfaces and utility functions
 * for todo item manipulation.
 */

/**
 * Core todo item interface.
 * Used by plan-mode for ephemeral plan steps.
 */
export interface TodoItem {
	/** Step number (1-indexed) */
	step: number;
	/** Short description of the todo */
	text: string;
	/** Whether the item is completed */
	completed: boolean;
}

/**
 * Extended todo interface for persistent todos.
 * Used by the todos extension for file-based storage.
 */
export interface TodoFrontMatter {
	/** Unique identifier (hex string) */
	id: string;
	/** Short summary title */
	title: string;
	/** Categorization tags */
	tags: string[];
	/** Status string (e.g., "open", "closed", "done") */
	status: string;
	/** ISO timestamp of creation */
	created_at: string;
	/** Session file that claimed this todo */
	assigned_to_session?: string;
}

/**
 * Full todo record with body content.
 */
export interface TodoRecord extends TodoFrontMatter {
	/** Long-form markdown body content */
	body: string;
}

/**
 * Clean step text by removing markdown formatting and truncating.
 */
export function cleanStepText(text: string): string {
	let cleaned = text
		.replace(/\*{1,2}([^*]+)\*{1,2}/g, "$1") // Remove bold/italic
		.replace(/`([^`]+)`/g, "$1") // Remove code
		.replace(
			/^(Use|Run|Execute|Create|Write|Read|Check|Verify|Update|Modify|Add|Remove|Delete|Install)\s+(the\s+)?/i,
			"",
		)
		.replace(/\s+/g, " ")
		.trim();

	if (cleaned.length > 0) {
		cleaned = cleaned.charAt(0).toUpperCase() + cleaned.slice(1);
	}
	if (cleaned.length > 50) {
		cleaned = `${cleaned.slice(0, 47)}...`;
	}
	return cleaned;
}

/**
 * Extract todo items from a message containing a "Plan:" section.
 * Looks for numbered steps under the Plan: header.
 */
export function extractTodoItems(message: string): TodoItem[] {
	const items: TodoItem[] = [];
	const headerMatch = message.match(/\*{0,2}Plan:\*{0,2}\s*\n/i);
	if (!headerMatch) return items;

	const planSection = message.slice(message.indexOf(headerMatch[0]) + headerMatch[0].length);
	const numberedPattern = /^\s*(\d+)[.)]\s+\*{0,2}([^*\n]+)/gm;

	for (const match of planSection.matchAll(numberedPattern)) {
		const text = match[2]
			.trim()
			.replace(/\*{1,2}$/, "")
			.trim();
		if (text.length > 5 && !text.startsWith("`") && !text.startsWith("/") && !text.startsWith("-")) {
			const cleaned = cleanStepText(text);
			if (cleaned.length > 3) {
				items.push({ step: items.length + 1, text: cleaned, completed: false });
			}
		}
	}
	return items;
}

/**
 * Extract completed step numbers from [DONE:n] markers in text.
 */
export function extractDoneSteps(message: string): number[] {
	const steps: number[] = [];
	for (const match of message.matchAll(/\[DONE:(\d+)\]/gi)) {
		const step = Number(match[1]);
		if (Number.isFinite(step)) steps.push(step);
	}
	return steps;
}

/**
 * Mark items as completed based on [DONE:n] markers in text.
 * Returns the number of items marked complete.
 */
export function markCompletedSteps(text: string, items: TodoItem[]): number {
	const doneSteps = extractDoneSteps(text);
	for (const step of doneSteps) {
		const item = items.find((t) => t.step === step);
		if (item) item.completed = true;
	}
	return doneSteps.length;
}

/**
 * Check if a status string indicates a closed/done todo.
 */
export function isTodoClosed(status: string): boolean {
	return ["closed", "done"].includes(status.toLowerCase());
}

/**
 * Sort todos: open assigned first, then open unassigned, then closed.
 */
export function sortTodos<T extends TodoFrontMatter>(todos: T[]): T[] {
	return [...todos].sort((a, b) => {
		const aClosed = isTodoClosed(a.status);
		const bClosed = isTodoClosed(b.status);
		if (aClosed !== bClosed) return aClosed ? 1 : -1;
		const aAssigned = !aClosed && Boolean(a.assigned_to_session);
		const bAssigned = !bClosed && Boolean(b.assigned_to_session);
		if (aAssigned !== bAssigned) return aAssigned ? -1 : 1;
		return (a.created_at || "").localeCompare(b.created_at || "");
	});
}

// Prefix for displayed todo IDs
export const TODO_ID_PREFIX = "TODO-";

/**
 * Format a raw hex id for display (e.g., "deadbeef" → "TODO-deadbeef").
 */
export function formatTodoId(id: string): string {
	return `${TODO_ID_PREFIX}${id}`;
}

/**
 * Normalize a todo id by removing prefix and # symbol.
 */
export function normalizeTodoId(id: string): string {
	let trimmed = id.trim();
	if (trimmed.startsWith("#")) {
		trimmed = trimmed.slice(1);
	}
	if (trimmed.toUpperCase().startsWith(TODO_ID_PREFIX)) {
		trimmed = trimmed.slice(TODO_ID_PREFIX.length);
	}
	return trimmed;
}

/**
 * Validate a todo id format.
 */
export function validateTodoId(id: string): { id: string } | { error: string } {
	const normalized = normalizeTodoId(id);
	const pattern = /^[a-f0-9]{8}$/i;
	if (!normalized || !pattern.test(normalized)) {
		return { error: "Invalid todo id. Expected TODO-<hex>." };
	}
	return { id: normalized.toLowerCase() };
}

/**
 * Get display-formatted todo id.
 */
export function displayTodoId(id: string): string {
	return formatTodoId(normalizeTodoId(id));
}
