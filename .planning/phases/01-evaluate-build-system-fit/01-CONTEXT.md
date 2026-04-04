# Phase 1: Evaluate Build-System Fit - Context

**Gathered:** 2026-04-04
**Status:** Ready for planning

<domain>
## Phase Boundary

This phase decides between Bazel and Meson + Ninja for PrusaSlicer's authoritative future build path. It defines the evaluation criteria, required proof, comparison scope, parity gates, and authority-cutoff rules. It does not migrate the product build itself beyond the minimum evidence needed to make the decision.

</domain>

<decisions>
## Implementation Decisions

### Decision criteria
- Reliability and repeatability are the top-ranked evaluation criteria.
- Contributor UX is the second-ranked criterion, ahead of maintenance burden, CI/platform fit, and dependency-model elegance.
- Developer ergonomics are a hard gate: weak `clangd`, editor metadata, formatting, or lint workflow can disqualify a candidate.
- Heavy bridge dependence is a major penalty unless it comes with a clear retirement story.
- Windows is neutral in Phase 1 and should not penalize a candidate unless future Windows support looks unusually painful.

### Proof bar
- Each candidate must produce a real PrusaSlicer app target plus at least one core test target on Linux before it is considered seriously viable.
- Final selection requires Linux proof plus at least one macOS smoke-build check.
- Each candidate must include a short onboarding note so contributor clarity is judged directly rather than assumed.
- Phase 1 must also define the exact CI commands the candidate would run, even if full CI lands later.

### Comparison scope
- The comparison must use one real app-oriented target path that reflects the actual product shape rather than toy or library-only targets.
- The comparison must include a representative slice of real dependency complexity so bridge pressure becomes visible early.
- The contributor workflows compared in Phase 1 must include build, tests, `clangd` or equivalent editor metadata, and format/lint command surface.
- The evaluation output should be a weighted scorecard plus hard-gate failures so the decision stays auditable later.

### Authority cutoff
- The new build path becomes authoritative only once Linux/macOS app builds, core tests, contributor tooling, and CI all work on the new path.
- After authority transfers, only explicitly tracked temporary legacy exceptions are allowed, each with an owner and retirement criteria.
- New build-related changes must land in the new build path first; legacy updates are allowed only for tracked exceptions.
- If Bazel fails the agreed hard gates, switching to Meson + Ninja is a valid success path for the project rather than a failure of the modernization effort.

### Claude's Discretion
- Exact weighting numbers for the scorecard can be chosen during planning as long as they preserve the agreed priority order and hard-gate behavior.
- The exact representative app target and test target can be selected during planning based on the most decision-informative slice of PrusaSlicer.
- The exact format of the comparison artifact can be chosen during planning as long as it remains auditable and easy to review.

</decisions>

<specifics>
## Specific Ideas

- Treat this as an engineering decision record, not a generic tool bake-off.
- Require real evidence rather than paper analysis alone.
- Use Linux as the deeper proof platform and require at least a macOS smoke-build check before making the final choice.
- Keep the candidate comparison anchored to real dependency difficulty and contributor ergonomics.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---
*Phase: 01-evaluate-build-system-fit*
*Context gathered: 2026-04-04*
