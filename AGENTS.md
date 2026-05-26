# PrusaSlicer Repo Agent Rules

These repo-level instructions supplement the global agent rules for this
repository.

## Bazel Command Surface and `justfile`

- Treat `./prusa` as the authoritative Bazel front door for contributor-facing
  workflows in this repo.
- Treat the repo-root `justfile` as an optional thin convenience layer. Keep
  recipes delegating to `./prusa` or to maintained proof commands already
  documented for contributors. Do not move build logic, platform resolution, or
  workflow ownership into `justfile`.
- When a change alters the public Bazel command surface, explicitly evaluate
  whether `justfile` should gain or update a convenience recipe.
- This rule applies to contributor-facing Bazel entrypoints, including:
  - changes to `./prusa` commands or flags
  - maintained proof commands already documented for contributors and mirrored
    in `justfile`
  - other contributor-facing Bazel command additions that are intentionally
    part of the public workflow
- This rule does not apply to every internal Bazel target, helper script,
  implementation-only config change, or other Bazel-adjacent internal detail.
- Add or update a `justfile` recipe when the command is likely to be run
  directly by contributors, improves discoverability, and can stay thin by
  delegating to `./prusa` or to an already-documented proof command.
- Do not add or expand `justfile` recipes when the change is internal-only,
  too narrow to justify a convenience command, or would force `justfile` to own
  logic that belongs in `./prusa` or the Bazel docs.
- If a public Bazel command-surface change does not lead to a `justfile`
  update, briefly state that decision and why in the final summary.
