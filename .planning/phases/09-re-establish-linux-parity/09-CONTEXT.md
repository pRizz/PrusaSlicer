---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 09-2026-04-09T08-46-33
generated_at: 2026-04-09T08:46:33Z
---

# Phase 9 Context: Re-establish Linux Parity

## Goal

Prove that the deeper owned runtime slice introduced in Phases 7 and 8 still builds and tests on Linux through the same public labels, while narrowing the Linux system-library exceptions so runtime and test-only deps are explicit.

## Decisions

- Use the same public `./prusa build --platform linux` and `./prusa test --platform linux` paths as the Phase 9 proof.
- Split the Linux exception story into runtime libs and test-only Catch2 instead of carrying one broad exception bucket.
- Keep the same public labels: `//src:PrusaSlicer`, `//src/CLI:bazel_owned_cli_test`, `//tests/libslic3r:config_test`, and `//tests/thumbnails:thumbnails_test`.
