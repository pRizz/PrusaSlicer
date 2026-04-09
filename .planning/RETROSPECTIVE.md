# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

## Milestone: v1.0 — Authoritative Build Path

**Shipped:** 2026-04-09
**Phases:** 6 | **Plans:** 15 | **Sessions:** Multi-session milestone

### What Was Built

- A scored Bazel-versus-Meson decision process with explicit parity gates and authority cutoff criteria
- A Bazel-first repo root with `MODULE.bazel`, `.bazelrc`, and the `./prusa` command surface
- A bounded real-product proof slice for `//src:PrusaSlicer` and `//tests/libslic3r:config_test` on macOS and Linux/arm64
- Real bounded test, format, lint, compdb, CI, and contributor-doc workflows on the authoritative path
- A verification/audit trail that closes the milestone with explicit traceability instead of summary-only claims

### What Worked

- Keeping the migration bounded to a real CLI/config slice prevented fake parity claims and preserved momentum.
- Centralizing bridges and system-library exceptions made later verification and audit work much easier.
- Using `./prusa` as the stable front door let local workflows and CI converge on one command surface early.

### What Was Inefficient

- Phase 3 initially oversized the proof slice and had to be replanned into smaller waves.
- Phase 3 verification was omitted during the first pass, which forced a dedicated milestone gap-closure phase.
- Linux clean-container verification is expensive enough that it should be planned deliberately, not treated as a cheap rerun.

### Patterns Established

- Prefer proof-slice migrations with explicit scope boundaries over broad partial ports.
- Add bridge inventories and exception registries at the same time the seam is introduced.
- Treat verification artifacts as first-class deliverables, not optional closeout paperwork.

### Key Lessons

1. If a phase claim matters to milestone completion, ship the `VERIFICATION.md` in the same phase instead of relying on summaries.
2. When a migration path starts widening unexpectedly, stop and replan around a smaller stable seam before implementation debt hardens.

### Cost Observations

- Model mix: Primarily balanced/orchestrator-led with focused subagent use for planning and audit support
- Sessions: Multi-session milestone spanning initialization, six phases, one milestone audit, and one gap-closure phase
- Notable: The up-front structure reduced ambiguity later, but missing one verification artifact still created an avoidable extra phase

---

## Cross-Milestone Trends

### Process Evolution

| Milestone | Sessions | Phases | Key Change |
|-----------|----------|--------|------------|
| v1.0 | Multi-session | 6 | Established a full discuss→plan→execute→verify→audit loop with milestone-grade traceability |

### Cumulative Quality

| Milestone | Tests | Coverage | Zero-Dep Additions |
|-----------|-------|----------|-------------------|
| v1.0 | Bounded Bazel proof targets plus authoritative CI | Milestone requirements 17/17 satisfied | 0 |

### Top Lessons (Verified Across Milestones)

1. Smaller proof slices and explicit bridge accounting make large build migrations tractable.
2. Verification artifacts need to ship with the implementation wave they validate.
