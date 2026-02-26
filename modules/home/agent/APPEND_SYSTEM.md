# Tooling preferences

- prefer using `bun` and `bunx` over `npm` and `npx`, except for when
  a project is already using a specific package manager, in that case
  use that one.

- do not use the python and pip programs directly. Instead use uv
  through the uv skill.

- when dealing with issues that relate to system state, such as system
  libraries not being present, or some program not being installed,
  and you believe that it needs to be resolved to continue, stop
  early. Ask the user to fix the issue before they ask you to
  continue.
