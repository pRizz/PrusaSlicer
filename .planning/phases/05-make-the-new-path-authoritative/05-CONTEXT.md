# Phase 5: Make the New Path Authoritative - Context

**Gathered:** 2026-04-08
**Status:** Ready for planning

<domain>
## Phase Boundary

This phase moves Linux/macOS CI and contributor guidance onto the Bazel-first local workflow so the repo has one enforceable source of truth and a clear legacy exit policy. It does not expand the bounded local tooling surface into fake whole-repo parity, and it does not add Windows, packaging, or release-pipeline migration beyond explicitly demoting them as non-authoritative legacy workflows.

</domain>

<decisions>
## Implementation Decisions

### CI gate
- Phase 5 should add one authoritative Linux/macOS CI workflow that runs the same Bazel-first commands contributors use locally.
- The authoritative CI should validate the bounded Phase 4 surface first: product build for the proven slice, bounded tests, formatting check, bounded lint, and compile-database refresh.
- Linux and macOS should each have explicit jobs in the authoritative workflow.
- Success means maintainers can point to one authoritative CI workflow for build/test/tooling changes on Linux and macOS.

### Legacy workflow posture
- Existing push-triggered legacy workflows should be clearly demoted so they no longer look like the primary gate for build/test/tooling changes.
- Legacy workflows for packaging, Windows, or older CMake-based paths may remain available as manual or explicitly non-authoritative exceptions.
- The repo should describe those legacy workflows as exceptions, not peers.
- Success means the automatic gate for build/test/tooling changes is the authoritative Bazel path, while legacy workflows are visibly secondary.

### Contributor guide
- Phase 5 should publish one maintained contributor guide for Linux and macOS that covers build, test, format, lint, and editor metadata from the Bazel-first path.
- Existing Linux/macOS CMake build guides should remain only as legacy exception references and should point back to the authoritative guide.
- The guide should name the exact commands and the bounded-surface caveats instead of hiding temporary exclusions.
- Success means contributors have one obvious maintained guide instead of stitching the workflow together from transition notes.

### Legacy exit policy
- The repo should state that new build/test/tooling changes land in the authoritative Bazel path first, with legacy updates only for tracked exceptions.
- The current bounded-surface exclusions and bridge inventories should remain visible during the authority transfer instead of being implied away.
- Authority means Bazel is the maintained gate for Linux/macOS contributor workflows, not that every legacy path has disappeared.
- Success means maintainers can explain what is authoritative, what is legacy, and how remaining legacy exceptions are retired.

### Claude's Discretion
- The exact authoritative CI workflow file name and job layout can be chosen during planning as long as Linux and macOS are both explicit and the workflow uses the same local command surface.
- The exact contributor-guide file path can be chosen during planning as long as one maintained guide becomes the obvious front door.
- The exact wording and placement of the legacy-exit policy can be chosen during planning as long as it is clear, reviewable, and consistent across README/docs/CI.

</decisions>

<specifics>
## Specific Ideas

- Prefer one new authoritative CI workflow over spreading authority across many existing reusable legacy workflows.
- Make the authoritative contributor guide explicit about the bounded Phase 4 surface and the remaining tracked exceptions.
- Demote, don’t silently delete: legacy workflows and guides should remain callable where needed, but they should stop reading as the default path.

</specifics>

<deferred>
## Deferred Ideas

- Windows authoritative CI
- Packaging/release pipeline migration
- Full whole-repo Bazel target parity
- Removing every legacy workflow file immediately

</deferred>

---
*Phase: 05-make-the-new-path-authoritative*
*Context gathered: 2026-04-08*
