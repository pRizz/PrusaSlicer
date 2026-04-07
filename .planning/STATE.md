# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-04-03)

**Core value:** Maintainers and contributors can build, test, and work on PrusaSlicer through a simple, repeatable, authoritative toolchain on Linux and macOS.
**Current focus:** Phase 5: Make the New Path Authoritative

## Current Position

Phase: 5 of 5 (Make the New Path Authoritative)
Plan: Not started
Status: Ready to discuss
Last activity: 2026-04-07 — Completed Phase 4 local tooling and validation execution

Progress: [████████░░] 80%

## Performance Metrics

**Velocity:**
- Total plans completed: 12
- Average duration: 5 min
- Total execution time: 0.0 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 01 | 4 | 21 min | 5 min |
| 02 | 2 | 9 min | 4 min |
| 03 | 4 | 3 min | 1 min |
| 04 | 2 | 0 min | 0 min |

**Recent Trend:**
- Last 5 plans: 0 min, 0 min, 2 min, 1 min, 0 min
- Trend: Stable

*Updated after each plan completion*

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- Initialization: Include an explicit Bazel vs Meson + Ninja evaluation phase
- Initialization: Linux and macOS are the first-class migration targets
- Initialization: Keep the project focused on build/tooling migration only
- Phase 01-01: Use a weighted scorecard plus hard gates and a real PrusaSlicer proof slice for the build-system decision
- Phase 01-02: Select Bazel as the Phase 2 target, with Meson + Ninja as the explicit fallback
- Phase 02-01: Use a thin `./prusa` wrapper as the Bazel-first repo front door instead of hiding Bazel or colliding with the existing `build/` directory
- Phase 02-02: Keep platform/toolchain work at placeholder skeleton scope and route all system-library exceptions through one centralized registry
- Phase 03 context: Use a CLI/core proof slice first, not a full GUI proof
- Phase 03 context: Treat macOS as the immediate proving ground, but require explicit Linux evidence in the same target shape
- Phase 03 context: Every bridge must be visible, scoped, and temporary by default
- Phase 03 replan: Replace the oversized 2-wave proof with a 4-wave dependency ladder, starting from a tiny macOS binary boundary and narrowing bridge scope aggressively
- Phase 03 complete: Prove the same bounded Bazel-owned binary/test slice on macOS and Linux/arm64 with explicit bridge and system-library classifications
- Phase 04 context: Make a bounded non-GUI core test surface, formatting flow, lint pass, and editor metadata path usable from Bazel before attempting CI authority work
- Phase 04 context: Prefer high-signal bounded tooling coverage with explicit exclusions over broad but noisy pseudo-parity
- Phase 04 complete: Make `./prusa test`, `fmt`, `lint`, and `compdb` real bounded Bazel-backed local workflows with explicit scope and a scratch-safe clangd metadata path

### Pending Todos

1 pending todo:

- Add justfile Bazel convenience commands (`tooling`) — capture a repo-root `justfile` that wraps common Bazel and `./prusa` workflows without changing the authoritative build path.

### Blockers/Concerns

- Phase 5 should move CI and contributor guidance onto the new path without silently widening the bounded local tooling surface into fake whole-repo parity.
- Remaining local-tooling exclusions and legacy exceptions must stay explicit during the authority-transfer phase.

## Session Continuity

Last session: 2026-04-07 17:52 CDT
Stopped at: Phase 4 complete, ready to begin Phase 5 discussion
Resume file: .planning/phases/04-add-local-tooling-and-validation/04-VERIFICATION.md
