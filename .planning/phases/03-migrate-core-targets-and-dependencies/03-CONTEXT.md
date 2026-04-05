# Phase 3: Migrate Core Targets and Dependencies - Context

**Gathered:** 2026-04-05
**Status:** Ready for planning

<domain>
## Phase Boundary

This phase migrates a real PrusaSlicer proof slice onto the Bazel-owned path for macOS and Linux, with explicit dependency ownership and visible bridge boundaries. It does not attempt full GUI migration, packaging work, CI completion, or broad toolchain/tooling polish beyond what the proof slice requires.

</domain>

<decisions>
## Implementation Decisions

### Proof slice
- The first real Bazel-owned product proof should be a CLI-capable `PrusaSlicer` binary path anchored on `src/PrusaSlicer.cpp`, `src/CLI/*`, and the core libraries it depends on.
- A representative core test target should be migrated alongside that build proof, ideally from `tests/libslic3r/`.
- GUI support is not required for the first Phase 3 proof; CLI/core comes first.
- Success should be judged against the same Bazel-owned target shape on both macOS and Linux.

### Dependency cut line
- Phase 3 should explicitly own only the minimum dependency set required to build the CLI/core proof slice and the selected representative core test target.
- Large or awkward dependencies may be bridged temporarily only when they directly block the proof slice.
- Generated headers or bespoke build products should be brought into Bazel only as far as the proof slice requires; do not port every generator in this phase.
- Success means a bounded set of proof-slice dependencies is explicitly owned in Bazel and the remaining bridges are visible and deliberate.

### Platform rollout
- macOS is the immediate proving ground because that is the environment available right now.
- Linux still needs explicit evidence in this phase, but it can follow the macOS-first path rather than leading it.
- Temporary platform asymmetry is acceptable only when it is documented against the same Bazel-owned target shape.
- Platform-specific blockers should be named as blockers against one shared migration target, not used to fork the design into platform-specific structures.

### Bridge discipline
- A temporary bridge is acceptable only if it unblocks the real CLI/core proof slice, is named in a bridge inventory, and has a retirement condition.
- Bridge usage should be highly visible in one inventory or policy location, with scope, owner, and reason.
- Every bridge is temporary by default unless explicitly justified otherwise.
- Success means maintainers can list every bridge used for the proof slice, explain why it exists, and state what would allow its removal.

### Claude's Discretion
- The exact representative core test target can be chosen during planning, as long as it stays inside the proof-slice boundary and is decision-informative.
- The exact bridge inventory format can be chosen during planning, as long as it stays centralized and reviewable.
- The exact order of dependency bring-up inside the proof slice can be chosen during planning, as long as it stays bounded to the agreed cut line.

</decisions>

<specifics>
## Specific Ideas

- Treat Phase 3 as the first real Bazel-owned product slice, not a broad “port everything” effort.
- Keep the target shape shared across macOS and Linux even if macOS is the faster proving ground.
- Prefer explicit blocker evidence and bridge accounting over pretending difficult dependencies are already solved.

</specifics>

<deferred>
## Deferred Ideas

- Full GUI-capable application proof as the first success condition
- Broad third-party ownership beyond the proof slice
- Packaging and release work
- CI completion and full tooling polish

</deferred>

---
*Phase: 03-migrate-core-targets-and-dependencies*
*Context gathered: 2026-04-05*
