# Roadmap: PrusaSlicer Build Stack Modernization

## Milestones

- ✅ **v1.0 Authoritative Build Path** — Phases 1-6 shipped 2026-04-09. Archive: [`v1.0-ROADMAP.md`](/Users/peterryszkiewicz/Repos/PrusaSlicer/.planning/milestones/v1.0-ROADMAP.md)
- ✅ **v1.1 Slice Deepening** — Phases 7-10 completed 2026-04-09. Ready to archive with `/gsd-complete-milestone`.

## Phases

<details>
<summary>✅ v1.0 Authoritative Build Path (Phases 1-6) — SHIPPED 2026-04-09</summary>

- [x] Phase 1: Evaluate Build-System Fit (4/4 plans) — completed 2026-04-04
- [x] Phase 2: Establish Build Graph Skeleton (2/2 plans) — completed 2026-04-04
- [x] Phase 3: Migrate Core Targets and Dependencies (4/4 plans) — completed 2026-04-06
- [x] Phase 4: Add Local Tooling and Validation (2/2 plans) — completed 2026-04-07
- [x] Phase 5: Make the New Path Authoritative (2/2 plans) — completed 2026-04-08
- [x] Phase 6: Backfill Verification Evidence (1/1 plans) — completed 2026-04-08

</details>

### ✅ v1.1 Slice Deepening (Complete)

- [x] **Phase 7: Replace Runtime Handoff** - Execute a real non-help CLI path through Bazel-owned source on macOS while preserving the existing public entry points
- [x] **Phase 8: Deepen Owned Runtime Slice** - Retire the temporary entry shim and replace at least one high-value dependency bridge with explicit owned/imported artifacts
- [x] **Phase 9: Re-establish Linux Parity** - Prove the deeper owned slice on Linux through the same public labels and keep platform exceptions minimal
- [x] **Phase 10: Refresh Remaining Bridge Contracts** - Close the milestone with an updated bridge inventory and verification story for the deeper slice

## Phase Details

### Phase 7: Replace Runtime Handoff
**Goal**: Execute a real non-help PrusaSlicer CLI workflow on macOS through Bazel-owned source while preserving the authoritative `./prusa` and `//src:PrusaSlicer` entry points.
**Depends on**: Phase 6
**Requirements**: [EXEC-01, EXEC-03, BRDG-01]
**Success Criteria** (what must be TRUE):
  1. Contributors can invoke at least one real non-help CLI workflow through `//src:PrusaSlicer` on macOS without the current legacy runtime handoff.
  2. Contributors still use the same authoritative `./prusa` command surface and `//src:PrusaSlicer` public label.
  3. The runtime handoff bridge is removed from the authoritative execution path or explicitly proven no longer necessary for the selected workflow.
**Plans**: 2 plans

Plans:
- [x] 07-01: Source-own one real non-help CLI execution path on macOS
- [x] 07-02: Preserve and verify the public command surface while retiring runtime handoff

### Phase 8: Deepen Owned Runtime Slice
**Goal**: Replace the temporary entry shim and pull one high-value dependency bridge into explicit Bazel ownership for the deeper slice.
**Depends on**: Phase 7
**Requirements**: [BRDG-02, DEEP-01]
**Success Criteria** (what must be TRUE):
  1. The temporary `src/BazelMain.cpp` entry shim is removed or reduced so it no longer defines the primary execution path.
  2. At least one high-value dependency bridge used by the deeper slice is replaced with explicit Bazel-owned or imported artifacts.
  3. The deeper slice remains reproducible on macOS under the same authoritative labels.
**Plans**: 2 plans

Plans:
- [x] 08-01: Replace or absorb the temporary entry shim into the owned slice
- [x] 08-02: Import one high-value dependency path explicitly into Bazel

### Phase 9: Re-establish Linux Parity
**Goal**: Prove the deeper owned runtime slice on Linux through the same public labels and keep platform-specific dependency exceptions minimal and explicit.
**Depends on**: Phase 8
**Requirements**: [EXEC-02, DEEP-02]
**Success Criteria** (what must be TRUE):
  1. Contributors can run the same deeper Bazel-owned CLI workflow on Linux through `//src:PrusaSlicer`.
  2. Linux and macOS continue to share the same public labels and command surface for the deepened slice.
  3. Remaining platform-specific dependency exceptions are minimal, explicit, and reproducible.
**Plans**: 2 plans

Plans:
- [x] 09-01: Prove the deeper runtime slice on Linux
- [x] 09-02: Normalize and document remaining cross-platform dependency exceptions

### Phase 10: Refresh Remaining Bridge Contracts
**Goal**: Close the milestone with an honest inventory of any remaining deep-slice bridges and a fresh verification story for the deeper owned slice.
**Depends on**: Phase 9
**Requirements**: [BRDG-03]
**Success Criteria** (what must be TRUE):
  1. Maintainers can list every remaining bridge in the deepened slice with owner and retirement criteria.
  2. Verification and docs prove the same public labels and `./prusa` surface remain authoritative after the slice deepening work.
  3. The milestone leaves Windows, packaging, and broader tooling ratchets clearly deferred rather than ambiguously half-started.
**Plans**: 1 plan

Plans:
- [x] 10-01: Refresh bridge inventory, verification, and milestone handoff

## Progress

| Milestone | Phase Range | Plans Complete | Status | Shipped |
|-----------|-------------|----------------|--------|---------|
| v1.0 Authoritative Build Path | 1-6 | 15/15 | Complete | 2026-04-09 |
| v1.1 Slice Deepening | 7-10 | 7/7 | Complete | 2026-04-09 |

## Next Up

**Complete Milestone** — Archive `v1.1 Slice Deepening` and prepare the next planning cycle

- Run `/gsd-complete-milestone`
- Run `/gsd-verify-work` if you want one more acceptance pass before archiving
