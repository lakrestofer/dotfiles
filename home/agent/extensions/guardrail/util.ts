import type { Program, SimpleCommand, Command, Statement, Word, WordPart } from "../../lib/sh/src/ast.js";



export function formatToolCall(toolName: string, params: Record<string, unknown>): string {
  const lines: string[] = [];

  for (const [key, value] of Object.entries(params)) {
    if (value === undefined || value === null) continue;

    let valueStr = String(value);
    if (valueStr.length > 100) {
      valueStr = valueStr.slice(0, 100) + "...";
    }
    if (valueStr.includes("\n")) {
      const firstLine = valueStr.split("\n")[0];
      valueStr = firstLine!.slice(0, 80) + "... (multi-line)";
    }

    lines.push(`  ${key}: ${valueStr}`);
  }

  return lines.join("\n");
}
/**
 * Resolve a Word node to its literal string value.
 * Concatenates Literal, SglQuoted, and simple DblQuoted parts.
 */
export function wordToString(word: Word): string {
  return word.parts.map(partToString).join("");
}

function partToString(part: WordPart): string {
  switch (part.type) {
    case "Literal":
      return part.value;
    case "SglQuoted":
      return part.value;
    case "DblQuoted":
      return part.parts.map(partToString).join("");
    case "ParamExp":
      return part.short
        ? `$${part.param.value}`
        : `\${${part.param.value}${part.op ?? ""}${part.value ? wordToString(part.value) : ""}}`;
    case "CmdSubst":
      return "$(...)";
    case "ArithExp":
      return `$((${part.expr}))`;
    case "ProcSubst":
      return `${part.op}(...)`;
  }
}


/**
 * Walk the AST and call `callback` for every SimpleCommand found at any
 * nesting depth. Returns early if callback returns `true`.
 */
export function walkCommands(
  node: Program,
  callback: (cmd: SimpleCommand) => boolean | undefined,
): void {
  for (const stmt of node.body) {
    if (walkStatement(stmt, callback)) return;
  }
}

function walkStatement(
  stmt: Statement,
  callback: (cmd: SimpleCommand) => boolean | undefined,
): boolean {
  return walkCommand(stmt.command, callback);
}

function walkStatements(
  stmts: Statement[],
  callback: (cmd: SimpleCommand) => boolean | undefined,
): boolean {
  for (const stmt of stmts) {
    if (walkStatement(stmt, callback)) return true;
  }
  return false;
}

function walkCommand(
  cmd: Command,
  callback: (cmd: SimpleCommand) => boolean | undefined,
): boolean {
  switch (cmd.type) {
    case "SimpleCommand":
      return callback(cmd) === true;
    case "Pipeline":
      return walkStatements(cmd.commands, callback);
    case "Logical":
      return (
        walkStatement(cmd.left, callback) || walkStatement(cmd.right, callback)
      );
    case "Subshell":
    case "Block":
      return walkStatements(cmd.body, callback);
    case "IfClause":
      return (
        walkStatements(cmd.cond, callback) ||
        walkStatements(cmd.then, callback) ||
        (cmd.else ? walkStatements(cmd.else, callback) : false)
      );
    case "ForClause":
    case "SelectClause":
    case "WhileClause":
      return (
        ("cond" in cmd && cmd.cond
          ? walkStatements(cmd.cond, callback)
          : false) || walkStatements(cmd.body, callback)
      );
    case "CaseClause":
      for (const item of cmd.items) {
        if (walkStatements(item.body, callback)) return true;
      }
      return false;
    case "FunctionDecl":
      return walkStatements(cmd.body, callback);
    case "TimeClause":
      return walkStatement(cmd.command, callback);
    case "CoprocClause":
      return walkStatement(cmd.body, callback);
    case "CStyleLoop":
      return walkStatements(cmd.body, callback);
    case "TestClause":
    case "ArithCmd":
    case "DeclClause":
    case "LetClause":
      return false;
  }
}


