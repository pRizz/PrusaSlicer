---
phase: 01-evaluate-build-system-fit
plan: 02
subsystem: infra
tags: [bazel, meson, evaluation, prototype, ci, clangd]
requires:
  - phase: 01-01
    provides: evaluation framework, proof scope, hard gates, authority cutoff
provides:
  - Candidate prototype artifacts for Bazel and Meson + Ninja
  - Weighted scorecard comparing both candidates
  - Build-system decision packet selecting Bazel with Meson fallback
affects: [phase-02, project-decisions]
tech-stack:
  added: []
  patterns: [phase-local candidate prototypes, scorecard-backed architecture decision]
key-files:
  created:
    - .planning/phases/01-evaluate-build-system-fit/01-candidate-scorecard.md
    - .planning/phases/01-evaluate-build-system-fit/01-build-system-decision.md
    - .planning/phases/01-evaluate-build-system-fit/prototypes/README.md
    - .planning/phases/01-evaluate-build-system-fit/prototypes/bazel/MODULE.bazel
    - .planning/phases/01-evaluate-build-system-fit/prototypes/bazel/BUILD.bazel
    - .planning/phases/01-evaluate-build-system-fit/prototypes/meson/meson.build
  modified:
    - .planning/PROJECT.md
key-decisions:
  - "Select Bazel as the authoritative Phase 2 target while keeping Meson + Ninja as explicit fallback"
  - "Treat missing Linux proof as an explicit uncertainty, not silent success"
patterns-established:
  - "Real-slice comparison with documented uncertainty instead of toy-target optimism"
  - "Decision packet backed by weighted scorecard plus hard-gate review"
requirements-completed: [EVAL-01, EVAL-02]
duration: 6 min
completed: 2026-04-04
---

# Phase 1 Plan 02 Summary

**Bazel selected as the Phase 2 build target through a scorecard-backed comparison against Meson + Ninja using real PrusaSlicer prototype slices**

## Performance

- **Duration:** 6 min
- **Started:** 2026-04-04T08:28:33Z
- **Completed:** 2026-04-04T08:34:35Z
- **Tasks:** 3
- **Files modified:** 8

## Accomplishments
- Built phase-local Bazel and Meson prototype sandboxes tied to a real PrusaSlicer app-oriented slice.
- Recorded a weighted scorecard and hard-gate review for both candidates with explicit uncertainty where Linux proof was unavailable.
- Wrote a decision packet selecting Bazel as the authoritative Phase 2 target and updated `PROJECT.md` accordingly.

## Task Commits

Each task was committed atomically:

1. **Task 1: Build the candidate evaluation sandbox and onboarding notes** - `67108d8d8` (chore)
2. **Task 2: Run the comparison and fill the weighted scorecard** - `0c98cd825` (docs)
3. **Task 3: Write the decision packet and record the outcome** - `d42b85014` (docs)

**Plan metadata:** To be recorded in the plan metadata commit that accompanies this summary.

## Files Created/Modified
- `.planning/phases/01-evaluate-build-system-fit/prototypes/README.md` - Candidate commands, proof scope, and anti-scope notes
- `.planning/phases/01-evaluate-build-system-fit/prototypes/bazel/MODULE.bazel` - Bazel Phase 1 prototype module with explicit `rules_cc` dependency
- `.planning/phases/01-evaluate-build-system-fit/prototypes/bazel/BUILD.bazel` - Bazel proof-slice targets for the app-oriented comparison
- `.planning/phases/01-evaluate-build-system-fit/prototypes/meson/meson.build` - Meson proof-slice targets for the same comparison scope
- `.planning/phases/01-evaluate-build-system-fit/01-candidate-scorecard.md` - Weighted scoring and hard-gate outcomes for Bazel vs Meson + Ninja
- `.planning/phases/01-evaluate-build-system-fit/01-build-system-decision.md` - Selected-candidate and fallback decision packet
- `.planning/PROJECT.md` - Added Phase 1 build-system selection to the project decision log

## Decisions Made
- Bazel is the selected Phase 2 target because it best matches the project’s highest-weighted goals: repeatability, explicit dependency ownership, and authoritative CI/build graph behavior.
- Meson + Ninja remains the explicit fallback because it is easier to prototype and has better near-term ergonomics.
- Linux proof remains an explicit uncertainty and must be one of the first confirmation gates in Phase 2.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Fixed prototype path depth so the comparison hit real repo files**
- **Found during:** Task 2 (candidate command execution)
- **Issue:** Both sandboxes initially symlinked `src/` and `tests/` one directory too shallow, causing setup failures before any meaningful repo evidence surfaced
- **Fix:** Corrected the symlink targets for both Bazel and Meson prototypes to point at the real repo paths
- **Files modified:** `.planning/phases/01-evaluate-build-system-fit/prototypes/bazel/src`, `.planning/phases/01-evaluate-build-system-fit/prototypes/bazel/tests`, `.planning/phases/01-evaluate-build-system-fit/prototypes/meson/src`, `.planning/phases/01-evaluate-build-system-fit/prototypes/meson/tests`
- **Verification:** Meson configured successfully and both candidates reached real source-compilation pressure
- **Committed in:** `0c98cd825` (Task 2 commit)

**2. [Rule 3 - Blocking] Added explicit Bazel module dependency for `rules_cc`**
- **Found during:** Task 2 (Bazel prototype execution)
- **Issue:** Bazel 9 refused to analyze the prototype because `rules_cc` was not declared in `MODULE.bazel`
- **Fix:** Added `bazel_dep(name = "rules_cc", version = "0.2.17")` to the prototype module and reran the build
- **Files modified:** `.planning/phases/01-evaluate-build-system-fit/prototypes/bazel/MODULE.bazel`
- **Verification:** Bazel progressed past module parsing and reached real compilation attempts against the selected source slice
- **Committed in:** `0c98cd825` (Task 2 commit)

**3. [Rule 3 - Blocking] Switched Meson setup to a local venv because system Python was PEP 668 managed**
- **Found during:** Task 2 (Meson tool bring-up)
- **Issue:** `python3 -m pip install --user meson==1.10.0` failed in the externally managed Homebrew Python environment
- **Fix:** Created a local phase-scoped virtual environment and installed Meson there for the comparison run
- **Files modified:** None persisted after cleanup
- **Verification:** Meson 1.10.0 configured and compiled the prototype far enough to surface real missing dependency/header failures
- **Committed in:** `0c98cd825` (Task 2 evidence reflected in scorecard)

---

**Total deviations:** 3 auto-fixed (3 blocking)
**Impact on plan:** All deviations were necessary to get meaningful candidate evidence instead of being blocked by avoidable sandbox/tooling mistakes. No scope creep into later migration phases.

## Issues Encountered
- Neither candidate produced Linux proof in this macOS environment, so the scorecard had to record that as explicit uncertainty rather than hard evidence.
- Meson reached compile faster and had the cleaner editor/tooling story.
- Bazel showed more up-front friction but aligned better with the project’s top-weighted long-term goals once it reached real source-compilation pressure.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Phase 2 can start from a documented Bazel-first decision rather than reopening the tool choice.
- The first confirmation gates in Phase 2 should be Linux proof, Linux core test proof, and Bazel editor-metadata viability.
- Meson + Ninja remains the valid fallback if Bazel fails those early confirmation gates.

---
*Phase: 01-evaluate-build-system-fit*
*Completed: 2026-04-04*
