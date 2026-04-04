# Phase 2: Establish Build Graph Skeleton - Context

**Gathered:** 2026-04-04
**Status:** Ready for planning

<domain>
## Phase Boundary

This phase puts the selected build system at the repository root with one obvious authoritative command surface and a centralized policy for platform branching and system-library exceptions. It does not perform full dependency migration, packaging migration, or broader Phase 3 product-target work.

</domain>

<decisions>
## Implementation Decisions

### Command surface
- The repo should expose a small root-level wrapper command set while still documenting the underlying Bazel commands.
- The top-level command names should be task-oriented, such as `build`, `test`, `fmt`, `lint`, and `compdb`.
- Existing CMake entry points should remain available if needed, but they should be clearly demoted in docs as legacy and non-authoritative.
- By the end of this phase, contributors should be able to discover one obvious root command path for build and test and understand that CMake is no longer the primary workflow.

### Root visibility
- Bazel should be obviously first-class at the repository root in this phase.
- Transitional indirection should be minimal: enough helper surface to guide contributors, but not enough to hide Bazel behind layers of abstraction.
- Existing root CMake files should stay in place, but Bazel should become the new front door in README and structure guidance.
- A contributor opening the repo root after this phase should infer: "This repo is moving to Bazel-first, and I know where to start."

### Platform policy
- Linux and macOS differences should be centralized and explicit in one obvious platform/toolchain area rather than scattered through targets.
- Temporary Linux/macOS asymmetry is acceptable if it is documented and centralized.
- Windows should only appear as a clear future extension point or placeholder, not as real Phase 2 implementation work.
- Success means maintainers can point to one centralized place that explains Linux/macOS branching, exception handling, and future platform extension points.

### System-library policy
- Source-fetched ownership is the default stance in this phase.
- A system-library exception is allowed only when it materially simplifies the skeleton and is documented with rationale, scope, and an explicit default preference for source-fetched ownership.
- Exceptions should be represented in one centralized policy location rather than hidden inside scattered target logic.
- By the end of this phase, maintainers should be able to explain which exceptions exist, why they exist, where they apply, and whether they are temporary or expected.

### Claude's Discretion
- The exact wrapper implementation can be chosen during planning as long as it keeps Bazel visible and task-oriented at the repo root.
- The exact location and naming of the centralized platform/toolchain and policy areas can be chosen during planning as long as they remain obvious and reviewable.
- The exact format of the system-library exception record can be chosen during planning as long as it is centralized and explicit.

</decisions>

<specifics>
## Specific Ideas

- The new root should feel Bazel-first without pretending CMake is already deleted.
- Root-level UX matters in this phase more than broad target coverage.
- Phase 2 should establish the structural front door and policy language that later phases can extend, not just drop Bazel files into the repo.

</specifics>

<deferred>
## Deferred Ideas

- Full dependency ownership migration — Phase 3
- Packaging/release migration — later phase
- Windows support implementation — later phase
- Full product-target coverage beyond the skeleton proof surface — Phase 3+

</deferred>

---
*Phase: 02-establish-build-graph-skeleton*
*Context gathered: 2026-04-04*
