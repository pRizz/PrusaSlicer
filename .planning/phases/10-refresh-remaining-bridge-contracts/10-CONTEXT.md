---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 10-2026-04-09T10-50-21
generated_at: 2026-04-09T10:55:53Z
---

# Phase 10: Refresh Remaining Bridge Contracts - Context

**Gathered:** 2026-04-09
**Status:** Ready for planning
**Mode:** Yolo

<domain>
## Phase Boundary

Close milestone `v1.1 Slice Deepening` by refreshing the remaining deep-slice
bridge inventory, aligning the authoritative Bazel docs with the actual
post-Phase-9 slice, and producing one fresh verification story that proves the
same public labels and `./prusa` front door still define the supported
Linux/macOS path.

</domain>

<decisions>
## Implementation Decisions

### Bridge Inventory
- **D-01:** Keep `tools/bazel/policies/proof_slice_bridges.md` as the single
  source of truth for remaining deep-slice bridge contracts.
- **D-02:** Refresh each remaining bridge row so the owner names the future
  slice or dependency track responsible for retirement instead of a generic
  “Bazel migration” label.
- **D-03:** Describe the still-supported handoff only for unsupported export,
  slice, and profile-query paths; the owned `--help` and `--save [--load ...]`
  workflows stay out of the remaining-bridge bucket.

### Documentation Alignment
- **D-04:** Remove stale Phase 3/Phase 4 framing from the Bazel docs and root
  README so the closeout reflects the current deeper owned slice.
- **D-05:** Keep `./prusa` and the existing public Bazel labels as the only
  authoritative contributor front door; convenience or legacy references may be
  documented only as explicit exceptions.
- **D-06:** Refresh the root README file lists so they follow the real
  `src/PrusaSlicer.cpp` entrypoint and the current bounded test/lint surfaces.

### Verification Closeout
- **D-07:** Re-run the authoritative macOS and Linux build/test proofs through
  `./prusa` and record them in `10-VERIFICATION.md`.
- **D-08:** Treat Phase 10 as a documentation and verification closeout phase,
  not another runtime-slice implementation phase.
- **D-09:** Keep Windows, packaging, Nyquist backfill, and broader tooling
  ratchets explicitly deferred rather than half-started.

### the agent's Discretion
- The exact doc wording may be tightened as long as the source-of-truth chain
  remains `README.md` -> `doc/Build and Tooling - Bazel.md` ->
  `tools/bazel/README.md` / `tools/bazel/policies/proof_slice_bridges.md`.
- The closeout verification may summarize command evidence concisely as long as
  the same public labels and `./prusa` surface are explicit.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Planning and Scope
- `.planning/ROADMAP.md` — Phase 10 goal, success criteria, and roadmap status.
- `.planning/REQUIREMENTS.md` — `BRDG-03` plus the already-completed v1.1
  execution and dependency requirements that Phase 10 must not regress.
- `.planning/PROJECT.md` — milestone goal, bounded edges, and deferrals that
  the closeout must preserve.
- `.planning/STATE.md` — current milestone position and known follow-up debt.

### Prior Phase Decisions and Evidence
- `.planning/phases/07-replace-runtime-handoff/07-CONTEXT.md` — narrowed the
  runtime handoff around the owned `--save [--load ...]` workflow.
- `.planning/phases/08-deepen-owned-runtime-slice/08-CONTEXT.md` — moved the
  primary entrypoint to `src/PrusaSlicer.cpp` and replaced the broad macOS
  runtime bundle with explicit imports.
- `.planning/phases/09-re-establish-linux-parity/09-CONTEXT.md` — kept the
  same public labels while splitting Linux runtime and test-only exceptions.
- `.planning/phases/09-re-establish-linux-parity/09-VERIFICATION.md` — latest
  Linux parity proof and current remaining-boundary wording.

### Authoritative Slice Docs and Policies
- `tools/bazel/policies/proof_slice_bridges.md` — remaining deep-slice bridge
  inventory that Phase 10 must refresh.
- `tools/bazel/policies/system_libraries.bzl` — explicit Linux/macOS
  system-library exception registry referenced by the closeout docs.
- `tools/bazel/README.md` — maintained Bazel slice narrative and bounded
  surface details.
- `doc/Build and Tooling - Bazel.md` — contributor-facing authoritative
  Linux/macOS workflow guide.
- `README.md` — repo-root authoritative workflow summary that must stay aligned
  with the deeper owned slice.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `./prusa` already provides the authoritative contributor front door, so Phase
  10 can verify and document the surface without adding another required entry
  point.
- `tools/bazel/policies/proof_slice_bridges.md` and
  `tools/bazel/policies/system_libraries.bzl` already centralize the remaining
  bridge and exception story.
- `tools/bazel/README.md`, `doc/Build and Tooling - Bazel.md`, and `README.md`
  already form the contributor-facing documentation chain that needs alignment.

### Established Patterns
- Prior closeout plans update both technical docs and `.planning` milestone
  traceability in the same phase.
- Verification reports use explicit command evidence plus a short “remaining
  explicit boundaries” section rather than claiming whole-repo parity.
- The repo keeps the Bazel-owned slice intentionally bounded and names deferred
  areas explicitly instead of soft-promising future parity.

### Integration Points
- `tools/bazel/policies/proof_slice_bridges.md` should stay synchronized with
  `tools/bazel/README.md` and `doc/Build and Tooling - Bazel.md`.
- Root README workflow notes should match the authoritative contributor docs
  instead of maintaining a stale, diverging copy.
- `.planning/{PROJECT,REQUIREMENTS,ROADMAP,STATE}.md` must reflect that Phase
  10 closes the planned v1.1 work.

</code_context>

<specifics>
## Specific Ideas

- Remove remaining references that still describe the current slice as “Phase 3
  proof” or “Phase 4” surfaces now that Phases 7-9 materially deepened the
  owned runtime path.
- Keep the bridge inventory table explicit about who owns each remaining bridge
  and what concrete future condition retires it.
- Use one fresh verification report to tie together the updated docs,
  macOS/Linux proof commands, and the still-deferred boundaries.

</specifics>

<deferred>
## Deferred Ideas

- Windows as a first-class authoritative target.
- Release packaging migration onto the Bazel path.
- Nyquist validation backfill across archived milestones.
- Repo-wide tooling ratchets beyond the current bounded slice.

### Reviewed Todos (not folded)
- `Add justfile Bazel convenience commands` — deferred because Phase 10 should
  close the milestone around the existing `./prusa` authority chain rather than
  introduce another contributor front door during closeout.

</deferred>

---

*Phase: 10-refresh-remaining-bridge-contracts*
*Context gathered: 2026-04-09*
