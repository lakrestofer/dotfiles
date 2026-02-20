import type { ParseOptions, ParseResult } from "./ast.js";
import { Parser } from "./parser/index.js";
import { tokenize } from "./tokenizer/index.js";

export function parse(source: string, options: ParseOptions = {}): ParseResult {
  const tokens = tokenize(source, options);
  const parser = new Parser(tokens, options);
  const ast = parser.parseProgram();
  parser.assertEof();
  return { ast };
}
