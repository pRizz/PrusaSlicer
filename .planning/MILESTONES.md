# Milestones

## v1.0 Authoritative Build Path (Shipped: 2026-04-09)

**Phases completed:** 6 phases, 15 plans, 27 tasks

**Key accomplishments:**

- Repo-specific Bazel vs Meson evaluation framework and proof runbook for real PrusaSlicer targets
- Bazel selected as the Phase 2 build target through a scorecard-backed comparison against Meson + Ninja using real PrusaSlicer prototype slices
- Linux proof executed for Bazel and Meson, replacing missing-proof uncertainty with concrete blocker evidence in the Phase 1 decision
- Bazel tooling-validation evidence captured, proving a concrete metadata failure path while keeping the Phase 1 decision auditable
- Bazel-first repo root skeleton with MODULE.bazel, .bazelrc, a thin ./prusa front door, and Bazel-first contributor docs
- Centralized Bazel platform skeleton and explicit system-library exception policy wired back into the repo front door
- Bazel-owned macOS `//src:PrusaSlicer` binary boundary proven with a narrow entry shim, bounded dependency metadata, and explicit bridge discipline
- Bazel-owned macOS `--help` seam proven behind `//src:PrusaSlicer`, with a smaller bridge surface and no remaining third-party dependency exception
- macOS `//tests/libslic3r:config_test` passes in Bazel against a bounded config-oriented seam shared with `//src:PrusaSlicer`
- Linux/arm64 now proves the same bounded Bazel-owned labels as macOS: `//src:PrusaSlicer` and `//tests/libslic3r:config_test`
- A bounded cross-platform Bazel test front door now exists through `./prusa test` and `//tools/bazel:test_suite`
- The placeholder local-tooling commands are now real: bounded `fmt`, `lint`, and `compdb` workflows run through the Bazel-first front door
- The repo now has one authoritative Linux/macOS Bazel CI workflow, and the old automatic legacy workflows no longer read as the primary gate
- The repo now has one maintained Bazel-first contributor guide, and the legacy build docs read as tracked exception references instead of the primary workflow
- Phase 3 verification evidence backfilled, milestone traceability reconciled, and the former audit blocker removed without reopening implementation scope

---
