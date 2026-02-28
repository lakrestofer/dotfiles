# Extend Pi Skill

This skill provides comprehensive guidance on extending pi's functionality using the various extension mechanisms available.

## What This Skill Covers

The skill describes **five primary ways** to extend pi:

1. **Prompt Templates** - Simple Markdown files for quick prompt shortcuts
2. **Skills** - Self-contained capability packages with scripts and documentation
3. **Extensions** - Full TypeScript modules for custom tools, event handling, and UI
4. **SDK** - Programmatic access to embed pi in other applications
5. **Packages** - Bundle and share extensions, skills, and templates

## Key Features

### Decision Framework
- **Decision tree** to help choose the right extension method
- **Clear criteria** for when to use each approach
- **Comparison table** showing complexity and use cases

### Comprehensive Coverage
- **How each method works** with code examples
- **Best practices** for each extension type
- **Common patterns** with references to examples
- **Security considerations** for each approach

### Practical Guidance
- **Quick reference** for locations, imports, and commands
- **Testing strategies** for each extension type
- **Debugging tips** and common issues
- **Source repository structure** for finding implementation details

### Cross-References
- Links to all relevant documentation
- Pointers to example implementations
- References to the pi-mono source repository

## When to Use This Skill

Use this skill when:
- A user wants to **customize pi's behavior**
- Someone needs **guidance on choosing an extension method**
- A developer wants to **create custom tools or commands**
- Someone wants to **integrate pi into another application**
- A user needs to **share extensions with others**

## Structure

The skill follows the Agent Skills standard with:
- **Frontmatter** with name and description
- **Overview section** comparing all methods
- **When to Use What** with detailed criteria for each method
- **Decision tree** for quick method selection
- **Key concepts** like event flow and state management
- **Common patterns** with code examples
- **Best practices** for each extension type
- **Testing and debugging** guidance
- **Quick reference** for common tasks

## Comparison with create-pi-extension Skill

The existing `create-pi-extension` skill focuses specifically on **creating extensions** (TypeScript modules). This new `extend-pi` skill is broader and:

- Covers **all five extension methods**, not just extensions
- Provides a **decision framework** to choose the right approach
- Includes **SDK usage** for programmatic integration
- Describes **package creation** for distribution
- Offers **comparative guidance** between methods

Both skills complement each other:
- Use `create-pi-extension` when you know you need an extension
- Use `extend-pi` when you're unsure which method to use

## References

The skill synthesizes information from:
- `docs/extensions.md` - Extension API documentation
- `docs/skills.md` - Skills specification
- `docs/prompt-templates.md` - Template format
- `docs/sdk.md` - SDK API reference
- `docs/packages.md` - Package creation guide
- `examples/extensions/` - 50+ extension examples
- `examples/sdk/` - SDK usage examples
- Pi-mono source repository structure

## Usage

Once loaded, pi will:
1. Include this skill in its system prompt (via progressive disclosure)
2. Load the full skill when tasks match the description
3. Use the guidance to recommend the appropriate extension method
4. Reference specific examples and documentation as needed

Users can also explicitly invoke it with:
```bash
/skill:extend-pi
```
