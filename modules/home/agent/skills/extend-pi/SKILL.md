---
name: extend-pi
description: Guide for extending pi with extensions, skills, prompt templates, SDK, and packages. Use when users want to customize or enhance pi's capabilities or integrate it into other applications.
---

# Extending Pi

This skill describes the various ways to extend pi's functionality and when to use each approach. Pi provides multiple extension mechanisms for different use cases, from simple prompt shortcuts to full programmatic control.

## Extension Methods Overview

Pi offers five primary ways to extend its functionality:

| Method | Best For | Complexity | Scope |
|--------|----------|------------|-------|
| **Prompt Templates** | Quick prompt shortcuts | Low | Single prompts |
| **Skills** | Domain-specific workflows with scripts | Medium | Task workflows |
| **Extensions** | Custom tools, event handling, UI | High | Deep integration |
| **SDK** | Embed pi in other applications | High | Application integration |
| **Packages** | Share extensions/skills/templates | Medium | Distribution |

## When to Use What

### Use Prompt Templates When:

- ✅ You need a quick way to invoke a common prompt
- ✅ You want simple argument substitution
- ✅ The prompt doesn't need computation or state
- ✅ You want minimal overhead (just Markdown files)

**Examples:**
- `/review` - Review staged git changes
- `/component Button` - Create a React component
- `/refactor MyClass` - Refactor a specific class

**How it works:**
1. Create a `.md` file in `~/.pi/agent/prompts/` or `.pi/prompts/`
2. Add frontmatter with description
3. Use `$1`, `$2`, `$@` for arguments
4. Type `/filename` to invoke

**Reference:** `docs/prompt-templates.md`

**Example:**
```markdown
---
description: Review staged git changes
---
Review the staged changes (`git diff --cached`). Focus on:
- Bugs and logic errors
- Security issues
- Error handling gaps
```

### Use Skills When:

- ✅ You have a multi-step workflow with helper scripts
- ✅ You need setup instructions or reference documentation
- ✅ The workflow requires external tools or APIs
- ✅ You want the LLM to discover and use the workflow
- ✅ You want to follow the Agent Skills standard

**Examples:**
- PDF processing (extract text, fill forms, merge)
- Web search via external APIs
- Database migrations with rollback
- Code generation with templates

**How it works:**
1. Create a directory with `SKILL.md` in `~/.pi/agent/skills/` or `.pi/skills/`
2. Add frontmatter (name, description, compatibility)
3. Include setup instructions and usage examples
4. Add helper scripts and reference docs
5. LLM discovers via system prompt, loads on-demand with `read`

**Reference:** `docs/skills.md`

**Example structure:**
```
my-skill/
├── SKILL.md              # Instructions
├── scripts/
│   └── process.sh        # Helper scripts
└── references/
    └── api-reference.md  # Detailed docs
```

### Use Extensions When:

- ✅ You need custom tools the LLM can call
- ✅ You want to intercept or modify tool calls
- ✅ You need user interaction (dialogs, confirmations)
- ✅ You want to react to lifecycle events
- ✅ You need stateful behavior across turns
- ✅ You want custom UI rendering in the TUI
- ✅ You need to register custom commands or keybindings

**Examples:**
- Permission gates (confirm before `rm -rf`)
- Git checkpointing (auto-stash on each turn)
- Custom tools (database queries, API calls)
- OAuth integrations
- Context injection from external sources
- Custom compaction strategies

**How it works:**
1. Create a `.ts` file in `~/.pi/agent/extensions/` or `.pi/extensions/`
2. Export a default function that receives `ExtensionAPI`
3. Register tools, subscribe to events, add commands
4. Test with `pi -e ./extension.ts`

**Reference:** `docs/extensions.md`, `examples/extensions/`

**Minimal example:**
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

  // Event handler
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName === "bash" && event.input.command?.includes("rm -rf")) {
      const ok = await ctx.ui.confirm("Dangerous!", "Allow?");
      if (!ok) return { block: true, reason: "Blocked" };
    }
  });

  // Custom command
  pi.registerCommand("mycommand", {
    description: "Does something",
    handler: async (args, ctx) => {
      ctx.ui.notify(`Args: ${args}`, "info");
    },
  });
}
```

### Use the SDK When:

- ✅ You want to embed pi in your own application
- ✅ You need programmatic control over sessions
- ✅ You're building a custom UI (web, desktop, mobile)
- ✅ You want to create automated workflows with agent reasoning
- ✅ You need to spawn sub-agents from within tools

**Examples:**
- Custom web UI for pi
- VSCode extension with pi integration
- Automated testing with agent reasoning
- Batch processing with agent capabilities
- Integration into existing applications

**How it works:**
1. Install `@mariozechner/pi-coding-agent` via npm
2. Create an `AgentSession` with `createAgentSession()`
3. Subscribe to events for streaming output
4. Send prompts programmatically
5. Control model, tools, and extensions

**Reference:** `docs/sdk.md`, `examples/sdk/`

**Minimal example:**
```typescript
import { createAgentSession, SessionManager, AuthStorage, ModelRegistry } from "@mariozechner/pi-coding-agent";

const authStorage = AuthStorage.create();
const modelRegistry = new ModelRegistry(authStorage);

const { session } = await createAgentSession({
  sessionManager: SessionManager.inMemory(),
  authStorage,
  modelRegistry,
});

session.subscribe((event) => {
  if (event.type === "message_update" && event.assistantMessageEvent.type === "text_delta") {
    process.stdout.write(event.assistantMessageEvent.delta);
  }
});

await session.prompt("What files are in the current directory?");
```

### Use Packages When:

- ✅ You want to share extensions, skills, or templates
- ✅ You need versioning and dependency management
- ✅ You want to distribute via npm or git
- ✅ You have multiple resources to bundle together
- ✅ You want your extensions/skills discoverable in the gallery

**Examples:**
- Company-wide extension bundles
- Open source skill collections
- Themed extension sets
- Integration packages (GitHub, Slack, etc.)

**How it works:**
1. Add `pi` manifest to `package.json`
2. Specify paths to extensions, skills, prompts, themes
3. Publish to npm or git
4. Install with `pi install npm:@scope/package` or `pi install git:github.com/user/repo`

**Reference:** `docs/packages.md`

**Example package.json:**
```json
{
  "name": "my-pi-package",
  "keywords": ["pi-package"],
  "pi": {
    "extensions": ["./extensions"],
    "skills": ["./skills"],
    "prompts": ["./prompts"]
  },
  "peerDependencies": {
    "@mariozechner/pi-coding-agent": "*",
    "@sinclair/typebox": "*"
  }
}
```

## Decision Tree

Use this flowchart to choose the right extension method:

```
Need to embed pi in another app?
├─ Yes → Use SDK
└─ No ↓

Need to share/distribute?
├─ Yes → Create Package
└─ No ↓

Need custom behavior?
├─ No (just prompt) → Use Prompt Template
└─ Yes ↓

Need external scripts/tools?
├─ Yes (and following standard) → Use Skill
└─ No ↓

Need programmatic control (tools, events, UI)?
├─ Yes → Create Extension
└─ No → Use Prompt Template
```

## Key Concepts

### Resource Discovery

Pi discovers resources from multiple locations:

**Global:**
- `~/.pi/agent/extensions/` - Extensions
- `~/.pi/agent/skills/` or `~/.agents/skills/` - Skills
- `~/.pi/agent/prompts/` - Prompt templates

**Project:**
- `.pi/extensions/` - Extensions
- `.pi/skills/` or `.agents/skills/` in cwd and ancestors - Skills
- `.pi/prompts/` - Prompt templates

**Settings:**
- `settings.json` can specify additional paths
- Packages installed via `pi install` go in settings

**Testing:**
- `pi -e ./extension.ts` - Test extension without installing
- `--skill <path>` - Load specific skill
- `--prompt-template <path>` - Load specific template

### Extension API Surface

Extensions have access to:

**Tools:**
- `pi.registerTool()` - Custom tools LLM can call
- `pi.getActiveTools()` / `pi.setActiveTools()` - Manage tool availability
- `pi.getAllTools()` - List all registered tools

**Events:**
- `pi.on(event, handler)` - Subscribe to lifecycle events
- Session events: `session_start`, `session_switch`, `session_fork`, etc.
- Agent events: `agent_start`, `agent_end`, `turn_start`, `turn_end`
- Tool events: `tool_call`, `tool_result`, `tool_execution_*`
- Input events: `input`, `user_bash`

**Commands:**
- `pi.registerCommand(name, options)` - Add `/command`
- `pi.getCommands()` - List available commands

**UI:**
- `ctx.ui.select()` - Selection dialog
- `ctx.ui.confirm()` - Confirmation dialog
- `ctx.ui.input()` - Text input
- `ctx.ui.notify()` - Notifications
- `ctx.ui.setStatus()` - Footer status
- `ctx.ui.setWidget()` - Widget above/below editor
- `ctx.ui.custom()` - Custom TUI components

**Session:**
- `ctx.sessionManager` - Read-only session access
- `pi.appendEntry()` - Persist extension state
- `pi.setSessionName()` - Set session display name
- `pi.setLabel()` - Label entries for bookmarking

**Messages:**
- `pi.sendMessage()` - Inject custom messages
- `pi.sendUserMessage()` - Send user messages programmatically

**Model Control:**
- `pi.setModel()` - Change active model
- `pi.getThinkingLevel()` / `pi.setThinkingLevel()` - Control thinking
- `pi.registerProvider()` - Add custom model providers

**Shortcuts & Flags:**
- `pi.registerShortcut()` - Add keybindings
- `pi.registerFlag()` - Add CLI flags

**Command Context:**
- `ctx.waitForIdle()` - Wait for agent to finish
- `ctx.newSession()` - Create new session
- `ctx.fork()` - Fork from entry
- `ctx.navigateTree()` - Tree navigation
- `ctx.reload()` - Reload extensions/skills/templates
- `ctx.compact()` - Trigger compaction

### Event Flow

Understanding event flow is crucial for extension development:

```
User sends prompt
  │
  ├─► input (can intercept/transform)
  ├─► before_agent_start (can inject message, modify system prompt)
  ├─► agent_start
  │
  │   ┌─── Turn (repeats while LLM calls tools) ───┐
  │   │                                            │
  │   ├─► turn_start                               │
  │   ├─► context (can modify messages)            │
  │   │                                            │
  │   │   LLM responds, may call tools:            │
  │   │     ├─► tool_call (can block)              │
  │   │     ├─► tool_execution_start               │
  │   │     ├─► tool_execution_update              │
  │   │     ├─► tool_execution_end                 │
  │   │     └─► tool_result (can modify)           │
  │   │                                            │
  │   └─► turn_end                                 │
  │                                                │
  └─► agent_end
```

### State Management

Extensions with state should:

1. **Store state in tool result `details`** for proper branching support
2. **Reconstruct state from session on startup**
3. **Use `pi.appendEntry()` for non-LLM state persistence**

Example:
```typescript
export default function (pi: ExtensionAPI) {
  let items: string[] = [];

  // Reconstruct state from session
  pi.on("session_start", async (_event, ctx) => {
    items = [];
    for (const entry of ctx.sessionManager.getBranch()) {
      if (entry.type === "message" && entry.message.role === "toolResult") {
        if (entry.message.toolName === "my_tool") {
          items = entry.message.details?.items ?? [];
        }
      }
    }
  });

  pi.registerTool({
    name: "my_tool",
    async execute(toolCallId, params, signal, onUpdate, ctx) {
      items.push("new item");
      return {
        content: [{ type: "text", text: "Added" }],
        details: { items: [...items] },  // Store for reconstruction
      };
    },
  });
}
```

## Source Repository

The pi source lives at `~/repos/pi-mono`. If not present, clone it:

```bash
git clone https://github.com/badlogic/pi-mono ~/repos/pi-mono
```

Always refer to the source for up-to-date API details.

### Repository Structure

```
~/repos/pi-mono/
├── packages/
│   ├── coding-agent/          # Main extension API
│   │   ├── src/
│   │   │   ├── core/
│   │   │   │   ├── extension.ts       # ExtensionAPI, events, types
│   │   │   │   ├── tools/             # Built-in tool implementations
│   │   │   │   └── session.ts         # SessionManager API
│   │   │   └── index.ts               # Public exports
│   │   ├── docs/                      # Full documentation
│   │   │   ├── extensions.md          # Extension guide
│   │   │   ├── skills.md              # Skills guide
│   │   │   ├── prompt-templates.md    # Templates guide
│   │   │   ├── sdk.md                 # SDK guide
│   │   │   ├── packages.md            # Package guide
│   │   │   ├── tui.md                 # TUI components
│   │   │   └── ...
│   │   └── examples/
│   │       ├── extensions/            # Working extension examples
│   │       └── sdk/                   # SDK examples
│   │
│   ├── tui/                   # TUI components
│   └── ai/                    # AI utilities
```

### Key Files to Read

When extending pi, read these source files:

| Need | File |
|------|------|
| Extension API, events | `packages/coding-agent/src/core/extension.ts` |
| Built-in tool examples | `packages/coding-agent/src/core/tools/*.ts` |
| TUI components | `packages/tui/src/components/*.ts` |
| Extension examples | `packages/coding-agent/examples/extensions/*.ts` |
| SDK examples | `packages/coding-agent/examples/sdk/*.ts` |
| Full docs | `packages/coding-agent/docs/*.md` |

## Common Patterns

### Permission Gate

Block dangerous commands with user confirmation:

```typescript
pi.on("tool_call", async (event, ctx) => {
  if (event.toolName === "bash" && event.input.command?.includes("rm -rf")) {
    const ok = await ctx.ui.confirm("Dangerous!", "Allow rm -rf?");
    if (!ok) return { block: true, reason: "Blocked by user" };
  }
});
```

See: `examples/extensions/permission-gate.ts`

### Git Checkpointing

Auto-stash on each turn:

```typescript
pi.on("turn_start", async (_event, ctx) => {
  await pi.exec("git", ["stash", "push", "-u", "-m", "auto-checkpoint"]);
});
```

See: `examples/extensions/git-checkpoint.ts`

### Custom Compaction

Provide custom summary logic:

```typescript
pi.on("session_before_compact", async (event, ctx) => {
  const { branchEntries, customInstructions } = event;
  
  // Generate custom summary
  const summary = await myCustomSummarizer(branchEntries, customInstructions);
  
  return {
    compaction: {
      summary,
      firstKeptEntryId: event.preparation.firstKeptEntryId,
      tokensBefore: event.preparation.tokensBefore,
    }
  };
});
```

See: `examples/extensions/custom-compaction.ts`, `docs/compaction.md`

### Input Transformation

Rewrite user input before LLM processing:

```typescript
pi.on("input", async (event, ctx) => {
  if (event.text.startsWith("?quick ")) {
    return { 
      action: "transform", 
      text: `Respond briefly: ${event.text.slice(7)}` 
    };
  }
  return { action: "continue" };
});
```

See: `examples/extensions/input-transform.ts`

### Custom Tool with Remote Execution

Override built-in tools to delegate to remote systems:

```typescript
import { createReadTool, type ReadOperations } from "@mariozechner/pi-coding-agent";

const remoteOps: ReadOperations = {
  readFile: (path) => sshExec(remote, `cat ${path}`),
  access: (path) => sshExec(remote, `test -r ${path}`).then(() => {}),
};

const remoteTool = createReadTool(cwd, { operations: remoteOps });
pi.registerTool(remoteTool);
```

See: `examples/extensions/ssh.ts`

### Interactive Tool with Custom UI

Create tools with rich user interaction:

```typescript
pi.registerTool({
  name: "my_interactive_tool",
  async execute(toolCallId, params, signal, onUpdate, ctx) {
    const choice = await ctx.ui.select("Pick one:", [
      "Option A",
      "Option B",
      "Option C"
    ]);
    
    if (!choice) {
      return { 
        content: [{ type: "text", text: "Cancelled" }],
        details: {}
      };
    }
    
    return {
      content: [{ type: "text", text: `Selected: ${choice}` }],
      details: { choice }
    };
  }
});
```

See: `examples/extensions/question.ts`, `examples/extensions/questionnaire.ts`

## Best Practices

### Extensions

1. **Use TypeScript** - Full type safety and IDE support
2. **Handle errors gracefully** - Always return valid results
3. **Support cancellation** - Check `signal?.aborted` in async operations
4. **Store state in tool results** - Enables proper session branching
5. **Truncate tool output** - Use `truncateHead`/`truncateTail` for large outputs
6. **Use `StringEnum` for enums** - Google's API doesn't support `Type.Union`
7. **Document your tools** - Clear descriptions help the LLM use them correctly
8. **Test with `-e`** - Quick testing without installation
9. **Use `/reload`** - Hot-reload during development
10. **Check `ctx.hasUI`** - Handle print/JSON mode gracefully

### Skills

1. **Follow Agent Skills standard** - Ensures compatibility with other harnesses
2. **Write clear descriptions** - Determines when LLM loads the skill
3. **Include setup instructions** - One-time setup before first use
4. **Use relative paths** - Reference scripts and assets from skill directory
5. **Document prerequisites** - Compatibility requirements in frontmatter
6. **Test `/skill:name` command** - Verify skill loads correctly
7. **Keep skills focused** - One domain/workflow per skill
8. **Provide examples** - Show concrete usage patterns

### Prompt Templates

1. **Keep them simple** - Just text expansion, no logic
2. **Use clear filenames** - Filename becomes the command
3. **Document arguments** - Explain what `$1`, `$2` mean
4. **Write good descriptions** - Shown in autocomplete
5. **Test argument substitution** - Verify `$@` and `${@:N}` work as expected

### SDK

1. **Handle events properly** - Subscribe before calling `prompt()`
2. **Manage lifecycle** - Call `dispose()` when done
3. **Use appropriate session storage** - In-memory for ephemeral, file-based for persistence
4. **Configure auth properly** - Set up `AuthStorage` and `ModelRegistry`
5. **Use tool factories with custom cwd** - `createReadTool(cwd)` instead of `readTool`
6. **Handle streaming** - Use `streamingBehavior` option when agent is active

### Packages

1. **Add `pi-package` keyword** - Enables gallery discovery
2. **Use peerDependencies** - Don't bundle pi core packages
3. **Version your package** - Semantic versioning for stability
4. **Test before publishing** - Install locally first
5. **Document setup** - README with installation and usage
6. **Handle dependencies** - Use `bundledDependencies` for pi packages

## Testing Extensions

### Local Testing

```bash
# Test single extension
pi -e ./my-extension.ts

# Test with specific model
pi -e ./my-extension.ts --model anthropic:claude-sonnet-4-5

# Test with minimal tools
pi -e ./my-extension.ts --no-tools
```

### Debugging

1. **Use `console.log()`** - Output appears in terminal
2. **Check `ctx.sessionManager`** - Inspect session state
3. **Use notifications** - `ctx.ui.notify()` for status updates
4. **Read source files** - Built-in tools are reference implementations
5. **Test events separately** - Isolate event handlers for testing

### Common Issues

**Tools not working:**
- Check `params` match `parameters` schema
- Verify `execute()` returns correct shape
- Look for thrown errors (not caught by pi)

**Events not firing:**
- Verify event name is correct
- Check handler is registered before event occurs
- Test with logging to confirm subscription

**UI methods failing:**
- Check `ctx.hasUI` - Methods no-op in print/JSON mode
- Verify you're in correct context (commands vs tools)
- Test dialog methods with timeout for auto-dismiss

**State not persisting:**
- Store state in tool result `details`
- Reconstruct from `ctx.sessionManager.getBranch()`
- Use `pi.appendEntry()` for non-LLM state

## Security Considerations

### Extensions

- Extensions run with **full system access**
- They can execute arbitrary code
- They can read/write files anywhere
- They can make network requests
- **Only install from trusted sources**

### Skills

- Skills can instruct the model to run any command
- They may include executable scripts
- **Review skill content before use**
- Check scripts for malicious code
- Verify external dependencies

### Packages

- Packages run `npm install` automatically
- They can install dependencies with postinstall scripts
- **Review source code before installing**
- Check package.json for suspicious dependencies
- Prefer packages from known authors

## Advanced Topics

### Custom Model Providers

Register custom OpenAI-compatible endpoints:

```typescript
pi.registerProvider("my-proxy", {
  baseUrl: "https://proxy.example.com",
  apiKey: "MY_API_KEY",
  api: "openai-responses",
  models: [
    {
      id: "my-model",
      name: "My Model",
      reasoning: false,
      input: ["text", "image"],
      cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
      contextWindow: 200000,
      maxTokens: 16384
    }
  ]
});
```

See: `docs/custom-provider.md`, `examples/extensions/custom-provider-*/`

### OAuth Integration

Add OAuth providers for `/login`:

```typescript
pi.registerProvider("corporate-ai", {
  baseUrl: "https://ai.corp.com",
  api: "openai-responses",
  models: [...],
  oauth: {
    name: "Corporate AI (SSO)",
    async login(callbacks) {
      callbacks.onAuth({ url: "https://sso.corp.com/..." });
      const code = await callbacks.onPrompt({ message: "Enter code:" });
      return { refresh: code, access: code, expires: Date.now() + 3600000 };
    },
    async refreshToken(credentials) {
      return credentials;
    },
    getApiKey(credentials) {
      return credentials.access;
    }
  }
});
```

See: `docs/custom-provider.md`, `examples/sdk/09-api-keys-and-oauth.ts`

### Custom TUI Components

Build rich interactive components:

```typescript
import { Container, Text, SelectList } from "@mariozechner/pi-tui";

const component = await ctx.ui.custom((tui, onClose) => {
  const items = ["Item 1", "Item 2", "Item 3"];
  const list = new SelectList(items, 0, 0, 40, 10, 0);
  
  list.onConfirm = (index) => {
    onClose(items[index]);
  };
  
  return new Container([list], 0, 0);
});
```

See: `docs/tui.md`, `examples/extensions/overlay-test.ts`

### Remote Tool Execution

Delegate tool execution to remote systems:

```typescript
import { createBashTool } from "@mariozechner/pi-coding-agent";

const bashTool = createBashTool(cwd, {
  spawnHook: ({ command, cwd, env }) => ({
    command: `ssh remote "cd ${cwd} && ${command}"`,
    cwd: process.cwd(),
    env,
  }),
});

pi.registerTool(bashTool);
```

See: `examples/extensions/ssh.ts`, `examples/extensions/bash-spawn-hook.ts`

## Related Documentation

### Core Docs
- `docs/extensions.md` - Full extension API reference
- `docs/skills.md` - Skills specification and guide
- `docs/prompt-templates.md` - Template format and usage
- `docs/sdk.md` - SDK API and examples
- `docs/packages.md` - Package creation and distribution

### Specialized Topics
- `docs/tui.md` - Custom UI components
- `docs/session.md` - Session storage and SessionManager API
- `docs/compaction.md` - Compaction system and customization
- `docs/tree.md` - Tree navigation and branching
- `docs/keybindings.md` - Keyboard shortcuts
- `docs/models.md` - Model configuration
- `docs/custom-provider.md` - Custom model providers
- `docs/rpc.md` - RPC integration
- `docs/themes.md` - Visual customization

### Examples
- `examples/extensions/` - 50+ extension examples
- `examples/sdk/` - SDK usage examples
- `examples/extensions/README.md` - Extension examples index

## Support and Resources

- **Source:** https://github.com/badlogic/pi-mono
- **Issues:** https://github.com/badlogic/pi-mono/issues
- **Packages:** https://shittycodingagent.ai/packages
- **Skills:** https://github.com/badlogic/pi-skills
- **Anthropic Skills:** https://github.com/anthropics/skills
- **Agent Skills Standard:** https://agentskills.io

## Process

When a user wants to extend pi:

1. **Understand the use case** - What are they trying to achieve?
2. **Choose the right method** - Use the decision tree above
3. **Check existing examples** - Look in `examples/extensions/` or skill repos
4. **Read relevant documentation** - Load docs from pi source
5. **Implement** - Create the extension/skill/template
6. **Test** - Use `-e`, `--skill`, or `--prompt-template` flags
7. **Install** - Move to global/project directory or create package
8. **Iterate** - Use `/reload` for hot-reloading during development

## Quick Reference

### Extension Locations
- Global: `~/.pi/agent/extensions/*.ts`
- Project: `.pi/extensions/*.ts`
- Test: `pi -e ./extension.ts`

### Skill Locations
- Global: `~/.pi/agent/skills/*/SKILL.md` or `~/.agents/skills/*/SKILL.md`
- Project: `.pi/skills/*/SKILL.md` or `.agents/skills/*/SKILL.md` (in cwd and ancestors)
- Test: `pi --skill ./my-skill/SKILL.md`

### Template Locations
- Global: `~/.pi/agent/prompts/*.md`
- Project: `.pi/prompts/*.md`
- Test: `pi --prompt-template ./template.md`

### Key Imports
```typescript
// Extension API
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

// Schema
import { Type } from "@sinclair/typebox";

// Enums (Google-compatible)
import { StringEnum } from "@mariozechner/pi-ai";

// TUI
import { Text, Container, SelectList } from "@mariozechner/pi-tui";

// SDK
import { 
  createAgentSession, 
  SessionManager, 
  AuthStorage, 
  ModelRegistry 
} from "@mariozechner/pi-coding-agent";
```

### Useful Commands
```bash
pi install npm:package         # Install package globally
pi install -l npm:package      # Install package to project
pi remove npm:package          # Remove package
pi list                        # List installed packages
pi config                      # Enable/disable resources
pi -e ./extension.ts           # Test extension
pi --skill ./skill/            # Test skill
pi --prompt-template ./tmpl.md # Test template
/reload                        # Hot-reload resources
```
