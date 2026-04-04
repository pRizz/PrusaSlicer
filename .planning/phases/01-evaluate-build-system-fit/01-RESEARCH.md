# Phase 1 Research: Evaluate Build-System Fit

**Researched:** 2026-04-04  
**Confidence:** HIGH

## Recommended Evaluation Artifact

Phase 1 should end with a decision packet, not just notes. The planner should produce a small set of artifacts that let later phases proceed without reopening the tool choice:
- a weighted scorecard for Bazel vs Meson + Ninja,
- a hard-gate checklist,
- a short recommendation with rationale,
- and a short rejection note for the losing candidate.

That makes the phase auditable and keeps the decision separate from implementation work.

## Candidate Proof Scope

Phase 1 needs real evidence, but not full migration. The proof bar should be:
- a real PrusaSlicer app-oriented target path on Linux,
- at least one core test target on Linux,
- a macOS smoke-build check,
- a short contributor-facing “how to use this” note,
- and a sketched CI command set that matches the local commands.

That is enough to compare build authority and contributor experience without turning Phase 1 into Phase 3.

Not enough for Phase 1:
- full dependency migration,
- packaging parity,
- Windows support,
- or removing CMake entirely.

## Representative Target Slice

The comparison should use the smallest slice that still reflects the real product:
- `src/PrusaSlicer.cpp`
- `src/CLI/`
- `src/libslic3r/`
- one representative core test suite under `tests/`

That slice exercises the layered CLI/app structure, the large core library, and the current Catch2/CTest test reality. It is a better decision sample than a toy library target because it exposes the build system to the same dependency and platform pressure the repo actually carries.

## Scorecard Dimensions

Use a weighted scorecard with hard gates on top. The user already set the priority order:

1. Reliability and repeatability
2. Contributor UX
3. Developer ergonomics
4. Dependency model quality
5. CI and cross-platform fit
6. Maintenance burden
7. Bridge pressure and retirement clarity

Practical scoring guidance:
- hard gates fail a candidate immediately,
- the weighted scorecard ranks candidates that clear the gates,
- and the evaluation should make the Bazel-vs-Meson tradeoff explainable to someone who was not in the room.

## Decision Gates

Treat these as hard gates for Phase 1:
- Linux app build works for the representative slice,
- at least one core Linux test target runs,
- macOS smoke-build is documented and credible,
- `clangd` or equivalent editor metadata is usable without the legacy build,
- format/lint invocation is documented,
- and the CI command shape is concrete enough to mirror local use.

The final decision should only be made when one candidate clearly wins the scorecard and both hard-gate proof and proof scope are satisfied.

If Bazel fails the hard gates, Meson + Ninja is still a successful outcome for the project. This phase is about choosing the best authoritative path, not forcing a predetermined winner.

## Risks To Avoid

Phase 1 should not drift into implementation work. Avoid these failure modes:
- translating the current CMake graph one-to-one and treating that as modernization,
- expanding into packaging or Windows,
- treating bridge mechanisms as the end state,
- or declaring success after a toy target builds but the real app slice does not.

The current repo already shows why this matters: the build is wired through `CMakeLists.txt`, per-target `CMakeLists.txt` files under `src/` and `tests/`, and a large dependency surface in `deps/` and `bundled_deps/`. Phase 1 has to decide whether the new system can handle that reality without recreating the same maintenance burden under a different syntax.

## Planning Implications

The planner should probably split Phase 1 into two plans:
- one plan to define evaluation criteria, proof bar, and authority cutoff rules,
- one plan to run the comparison and record the decision.

That split matches the roadmap and keeps the first plan focused on decision structure rather than implementation detail.

The planner should also treat the selected build system as a decision input for later phases, not as a foregone conclusion. The output needs to be strong enough that Phase 2 can start building the root authoritative graph without re-litigating the choice.

## Sources

Primary sources:
- https://bazel.build/release#bazel-versioning
- https://bazel.build/external/overview
- https://mesonbuild.com/Dependencies.html
- https://mesonbuild.com/Subprojects.html
- https://mesonbuild.com/Wrap-dependency-system-manual.html
- https://clangd.llvm.org/installation.html
- https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/run-job-variations
- https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-jobs

Project-local context:
- `.planning/PROJECT.md`
- `.planning/ROADMAP.md`
- `.planning/REQUIREMENTS.md`
- `.planning/STATE.md`
- `.planning/phases/01-evaluate-build-system-fit/01-CONTEXT.md`
- `.planning/research/SUMMARY.md`
- `.planning/codebase/ARCHITECTURE.md`
- `.planning/codebase/STRUCTURE.md`

---
*Phase: 01-evaluate-build-system-fit*
*Research gathered: 2026-04-04*
