---
name: extension-creator
description: Guide for creating pi extensions. Use when users want to create, modify, or debug extensions that extend pi's behavior with custom tools, commands, event handlers, or UI components.
---

# Extension Creator

Extensions are TypeScript modules that extend pi's behavior via custom tools, commands, event handlers, and UI.

## Source Repository

The pi source lives at `~/repos/pi-mono`. If not present, clone it:

```bash
git clone https://github.com/badlogic/pi-mono ~/repos/pi-mono
```

Always refer to the source for up-to-date API details.

## Repository Structure

```
~/repos/pi-mono/
├── packages/
│   ├── coding-agent/          # Main extension API
│   │   ├── src/
│   │   │   ├── core/
│   │   │   │   ├── extension.ts       # ExtensionAPI, events, types
│   │   │   │   ├── tools/             # Built-in tool implementations
│   │   │   │   │   ├── read.ts
│   │   │   │   │   ├── bash.ts
│   │   │   │   │   ├── edit.ts
│   │   │   │   │   └── write.ts
│   │   │   │   └── session.ts         # SessionManager API
│   │   │   └── index.ts               # Public exports
│   │   └── docs/
│   │       └── extensions.md          # Extension documentation
│   │
│   ├── tui/                   # TUI components
│   │   └── src/
│   │       ├── components/            # Text, Container, SelectList, Input, etc.
│   │       └── index.ts               # Public exports
│   │
│   └── ai/                    # AI utilities (StringEnum, etc.)
│
└── examples/
    └── extensions/            # Working extension examples
        ├── hello.ts           # Minimal tool
        ├── commands.ts        # Custom command
        ├── permission-gate.ts # Event interception
        ├── tools.ts           # Tool management
        ├── todo.ts            # Complex stateful tool
        └── ...
```

## Key Files to Read

When building extensions, read these source files:

| Need | File |
|------|------|
| Extension API, events | `packages/coding-agent/src/core/extension.ts` |
| Built-in tool examples | `packages/coding-agent/src/core/tools/*.ts` |
| TUI components | `packages/tui/src/components/*.ts` |
| Working examples | `examples/extensions/*.ts` |
| Full documentation | `packages/coding-agent/docs/extensions.md` |

## Extension Locations

| Location | Scope |
|----------|-------|
| `~/.pi/agent/extensions/*.ts` | Global |
| `.pi/extensions/*.ts` | Project-local |

Test with `pi -e ./my-extension.ts`. Use `/reload` to hot-reload.

## Minimal Extension

```typescript
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";

export default function (pi: ExtensionAPI) {
  // Custom tool
  pi.registerTool({
    name: "my_tool",
    label: "My Tool",
    description: "What this tool does",
    parameters: Type.Object({
      text: Type.String({ description: "Input text" }),
    }),
    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return {
        content: [{ type: "text", text: `Got: ${params.text}` }],
        details: {},
      };
    },
  });

  // Custom command
  pi.registerCommand("mycommand", {
    description: "Does something",
    handler: async (args, ctx) => {
      ctx.ui.notify(`Args: ${args}`, "info");
    },
  });

  // Event handler
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName === "bash" && event.input.command?.includes("rm -rf")) {
      const ok = await ctx.ui.confirm("Dangerous!", "Allow?");
      if (!ok) return { block: true, reason: "Blocked" };
    }
  });
}
```

## Imports

```typescript
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";  // For enum parameters
import { Text, Container, SelectList } from "@mariozechner/pi-tui";  // TUI components
```

## Process

1. Check if `~/repos/pi-mono` exists; clone if not
2. Read relevant source files for the feature needed
3. Look at similar examples in `examples/extensions/`
4. Implement the extension
5. Test with `pi -e ./extension.ts`
6. Move to `~/.pi/agent/extensions/` or `.pi/extensions/` for auto-discovery
