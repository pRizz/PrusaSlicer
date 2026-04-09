---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 07-2026-04-09T07-29-06
generated_at: 2026-04-09T07:29:06Z
---

# Phase 7 Context: Replace Runtime Handoff

## Goal

Source-own one real non-help CLI workflow on macOS behind the stable `//src:PrusaSlicer` label and the existing `./prusa` front door, while narrowing the legacy runtime handoff instead of pretending Phase 7 can remove every fallback path at once.

## Decisions

- Use `--save <file>` with optional repeated `--load <file>` as the first owned non-help CLI workflow.
- Keep the public command surface unchanged: `//src:PrusaSlicer` and `./prusa build` remain the authoritative entry points.
- Treat Phase 7 as a handoff-narrowing phase, not a whole-runtime replacement phase.
- Keep preset queries, model export, slicing, Windows, and packaging out of scope for this phase.
- Add a focused regression guard for the new owned CLI seam instead of relying only on manual verification.

## Constraints

- The current owned slice is still config-oriented; avoid dragging in broad model, preset, or GUI runtime work.
- macOS is the proving ground for this phase; Linux parity follows in Phase 9.
- Remaining handoff paths must stay explicitly documented in the bridge inventory.
