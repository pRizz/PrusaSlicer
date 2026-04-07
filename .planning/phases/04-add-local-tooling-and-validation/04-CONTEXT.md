# Phase 4: Add Local Tooling and Validation - Context

**Gathered:** 2026-04-07
**Status:** Ready for planning

<domain>
## Phase Boundary

This phase makes the Bazel path credible for daily contributor use by wiring local tests, formatting, lint/static analysis, and editor metadata into the authoritative workflow. It does not move CI onto the new path or complete the legacy-authority cutover; that remains Phase 5 work.

</domain>

<decisions>
## Implementation Decisions

### Test surface
- Phase 4 should make a bounded non-GUI core test surface authoritative first, anchored on the migrated proof slice and starting with `//tests/libslic3r:config_test`.
- The same Bazel test labels should run on Linux and macOS, with only explicitly tracked temporary gaps.
- Legacy CTest entry points should remain only for tracked exceptions; Bazel becomes the documented local front door for tests.
- Success means contributors have one documented smoke set per platform plus at least one broader core regression-oriented target runnable from the new path.

### Formatting workflow
- Phase 4 should provide a repo-usable formatting path for the main C/C++ contributor surface, even if some edge directories are deferred.
- Formatting should expose separate `check` and `fix` entry points.
- Any directories or file classes that are not yet safely formattable should be excluded explicitly and documented rather than treated as silently covered.
- Success means contributors can run one obvious format-check and format-fix workflow from the new path and understand what is in or out of scope.

### Lint pass
- The initial lint/static-analysis pass should optimize for high-signal bounded checks that contributors will trust and use.
- Lint should target the migrated Bazel-owned slice plus a small adjacent contributor surface where the signal remains manageable.
- Failures should be actionable on that bounded lint surface, while noisier categories are explicitly deferred instead of flooding the command with low-value output.
- Success means contributors can run one documented lint command from the new path, get mostly actionable results, and understand what is intentionally deferred.

### Editor metadata
- The `clangd` or equivalent editor-metadata experience should center on one obvious command that generates or refreshes usable metadata for the authoritative Bazel slice.
- Refresh should be explicit and cheap, with clear guidance on when contributors need to rerun it.
- Phase 4 should prefer one conventional output location or command shape that editors can reliably point at.
- Success means contributors can point `clangd` or an equivalent editor workflow at Bazel-generated metadata for the migrated slice without invoking legacy build generation.

### Claude's Discretion
- The exact test targets added beyond `//tests/libslic3r:config_test` can be chosen during planning as long as they stay bounded, non-GUI, and cross-platform.
- The exact formatter, lint/static-analysis tool, and editor-metadata generator can be chosen during planning as long as each is exposed through one obvious authoritative command path.
- The exact naming and placement of the new local tooling commands can be chosen during planning as long as check/fix scope and exclusions stay explicit.

</decisions>

<specifics>
## Specific Ideas

- Keep the local tooling surface obvious and contributor-facing, not just a collection of raw Bazel subcommands.
- Prefer a smaller trustworthy test/lint/format/editor surface over broad but noisy pseudo-coverage.
- Make exclusions and temporary gaps visible so contributors know what the new path actually covers.

</specifics>

<deferred>
## Deferred Ideas

- CI enforcement and gating changes
- Full legacy CTest parity
- Whole-repo formatting or lint enforcement on every directory immediately
- Magical always-fresh editor metadata
- Final authority transfer away from the legacy build

</deferred>

---
*Phase: 04-add-local-tooling-and-validation*
*Context gathered: 2026-04-07*
