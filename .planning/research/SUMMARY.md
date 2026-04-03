# Project Research Summary

**Project:** PrusaSlicer Build Stack Modernization
**Domain:** Brownfield build and tooling modernization for a large C++ desktop application
**Researched:** 2026-04-03
**Confidence:** HIGH

## Executive Summary

This is not a greenfield build-system choice; it is a migration of an existing C++17 desktop application with substantial dependency and platform baggage. The research points toward treating this as a staged authority transfer: first choose the right build system with explicit criteria, then use that choice to establish a Linux/macOS-first authoritative path for building the app, running core tests, and supporting contributor tooling.

Bazel is the strongest fit for the stated goals of simplicity, repeatability, and reliability if the repo can absorb the rule-ownership cost. Its graph model, Bzlmod dependency system, and CI ergonomics line up with the user's goals better than the current CMake-first approach. Meson + Ninja remains the most credible fallback because it offers simpler C/C++ ergonomics and a saner modernization story than legacy CMake if Bazel proves too painful in practice.

The main risks are not tool-specific hype but migration failure patterns: keeping dual build authority too long, porting old complexity without simplifying it, overusing bridge layers, and neglecting contributor ergonomics such as `clangd`, formatting, linting, and CI parity. The roadmap should therefore front-load evaluation criteria, target ownership, and contributor workflow quality instead of delaying them until after a nominal build succeeds.

## Key Findings

### Recommended Stack

The strongest stack recommendation is Bazel 9 with Bzlmod, backed by a pinned LLVM/Clang toolchain line and a narrow set of bridge mechanisms for hard legacy islands. That combination best matches the desire for a reproducible dependency story, an authoritative build graph, and one coherent set of compiler/editor/tooling behaviors across local development and CI.

Meson + Ninja is the right fallback, not because it is stronger than Bazel on repeatability, but because it is materially more approachable for C/C++ codebases if Bazel-native rule ownership becomes too expensive. In either case, the migration should unify around LLVM tooling, explicit dependency provenance, and first-class validation targets.

**Core technologies:**
- Bazel 9 + Bzlmod: authoritative build graph and dependency model — strongest fit for repeatability and reliability
- LLVM/Clang 22.1.x line: compiler, formatter, linter, editor server, and sanitizers — reduces tooling drift
- `rules_foreign_cc` or equivalent bridge: temporary migration aid — useful only for hard-to-migrate legacy islands

### Expected Features

The research treats this migration like a product with table stakes and anti-features. Table stakes are: one authoritative build entry point, Linux/macOS app builds, core test execution, reproducible dependency handling, contributor tooling support, and CI enforcement. A modernization effort that lacks any of those is not yet credible.

**Must have (table stakes):**
- One authoritative build path — contributors need one real source of truth
- Linux/macOS app builds — these are the first-class migration targets
- Core test execution — existing quality signals must survive the migration
- Reproducible dependency handling — directly tied to the stated repeatability goal
- `clangd` / format / lint support — contributor UX cannot be a casualty
- CI using the same targets as local dev — authority must be enforceable

**Should have (competitive):**
- Explicit Bazel vs Meson evaluation phase — prevents ideology-driven tool selection
- Lockfile-driven dependency provenance — makes upgrades and auditing clearer
- Standardized LLVM tooling spine — keeps editor, lint, and compile behavior aligned

**Defer (v2+):**
- Windows support under the new path — important, but intentionally sequenced later
- Full packaging and release parity — adjacent to authority, not required before it

### Architecture Approach

The recommended architecture is a staged overlay: define migration policy and success criteria first, then establish an authoritative build-definition layer, a centralized toolchain/dependency layer, and a validation layer for build/test/tooling/CI. Legacy build glue is allowed only behind explicit bridge boundaries with documented exit criteria.

**Major components:**
1. Evaluation policy — chooses Bazel or Meson using explicit migration criteria
2. Authoritative build definitions — owns targets, dependencies, and platform conditions
3. Toolchain and dependency layer — pins LLVM tooling and source-fetched third-party inputs
4. Validation layer — owns app builds, tests, linting, editor metadata, and CI
5. Legacy boundary — tracks temporary overlap and forces explicit retirement

### Critical Pitfalls

1. **Permanent dual authority** — set explicit cutoff gates and owners for overlap
2. **Syntax-level CMake translation** — port behavior and boundaries, not historical macro shape
3. **Bridge layers becoming architecture** — use them only as temporary scaffolding
4. **Editor support afterthought** — include `clangd`, formatting, and linting in the first authority milestone
5. **CI/local divergence** — run the same authoritative targets in both places

## Implications for Roadmap

Based on research, suggested phase structure:

### Phase 1: Evaluate and Set Migration Policy
**Rationale:** The repo needs explicit selection criteria before committing to Bazel or Meson.
**Delivers:** Tool evaluation, success metrics, parity gates, and authority cutoff policy.
**Addresses:** Tool selection, scope control, Linux/macOS-first sequencing.
**Avoids:** Permanent dual authority and scope explosion.

### Phase 2: Establish the Authoritative Graph Skeleton
**Rationale:** The new build needs visible root ownership and target boundaries before deep dependency work.
**Delivers:** Root build files, target conventions, toolchain layout, platform config, and initial app/test targets.
**Uses:** Bazel 9 + Bzlmod if selected, or Meson + Ninja fallback.
**Implements:** Build-definition and toolchain architecture.

### Phase 3: Migrate Dependencies and Core Product Targets
**Rationale:** Real authority depends on building the app and tests with an explicit dependency model.
**Delivers:** Mostly source-fetched dependencies, bridge strategy for hard legacy islands, Linux/macOS app builds, core tests.
**Uses:** Dependency provenance rules and bridge retirement inventory.
**Implements:** Product target and third-party ownership boundaries.

### Phase 4: Tooling and Contributor UX
**Rationale:** The new path is not authoritative if contributors still need legacy tooling for daily work.
**Delivers:** Formatting, linting, `clangd`/compile metadata support, sanitizer entry points, contributor docs.
**Uses:** LLVM/Clang tooling spine.
**Implements:** Validation and ergonomics targets.

### Phase 5: CI Authority and Legacy Exit
**Rationale:** The new path becomes authoritative only when CI and docs enforce it.
**Delivers:** Linux/macOS CI matrix, reproducibility checks, documented contributor workflow, legacy overlap removal plan.
**Uses:** GitHub Actions matrix and authoritative validation targets.
**Implements:** CI and authority transition.

### Phase Ordering Rationale

- Tool selection and migration policy come first because they govern every downstream target and dependency decision.
- App/test authority comes before packaging and Windows because the user explicitly prioritized Linux/macOS core workflows.
- Contributor tooling is placed before final legacy exit so authority is earned socially as well as technically.
- Packaging and Windows belong after core authority, not before it.

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 1:** Bazel vs Meson trade study for wxWidgets/OpenGL-heavy desktop app realities
- **Phase 3:** Third-party dependency migration strategy, especially for customized or awkward dependencies
- **Phase 5:** Packaging/release integration strategy once the core path is stable

Phases with standard patterns (skip research-phase):
- **Phase 4:** Formatting, linting, `clangd`, and sanitizer setup are well-understood once the build graph and toolchain are chosen

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Core recommendations are grounded in current official Bazel, Meson, LLVM, and GitHub Actions docs |
| Features | HIGH | Migration requirements align strongly with the user’s stated goals and common build-modernization expectations |
| Architecture | HIGH | Recommended layering follows standard migration patterns and the current repo’s brownfield constraints |
| Pitfalls | HIGH | Failure modes are consistent with the repo’s current concerns and common large-repo migration risks |

**Overall confidence:** HIGH

### Gaps to Address

- Bazel-specific desktop-app friction for this repo’s exact third-party mix still needs validation during planning
- The chosen path’s editor metadata solution should be validated early rather than assumed
- Packaging and release integration should remain out of the first authority milestone unless planning proves it is unexpectedly cheap

## Sources

### Primary (HIGH confidence)
- [.planning/research/STACK.md](/Users/peterryszkiewicz/Repos/PrusaSlicer/.planning/research/STACK.md) — stack recommendation and official source links
- [.planning/research/FEATURES.md](/Users/peterryszkiewicz/Repos/PrusaSlicer/.planning/research/FEATURES.md) — feature landscape for the migration
- [.planning/research/ARCHITECTURE.md](/Users/peterryszkiewicz/Repos/PrusaSlicer/.planning/research/ARCHITECTURE.md) — architecture and phase implications
- [.planning/research/PITFALLS.md](/Users/peterryszkiewicz/Repos/PrusaSlicer/.planning/research/PITFALLS.md) — migration failure modes
- https://bazel.build/docs — Bazel docs
- https://bazel.build/docs/bzlmod — Bazel dependency model
- https://mesonbuild.com/Dependencies.html — Meson dependency handling
- https://mesonbuild.com/Subprojects.html — Meson subprojects
- https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs — CI matrix guidance
- https://clangd.llvm.org/installation.html — editor support guidance

### Secondary (MEDIUM confidence)
- `.planning/codebase/ARCHITECTURE.md` — current product boundaries
- `.planning/codebase/CONCERNS.md` — current build/dependency fragility

### Tertiary (LOW confidence)
- None

---
*Research completed: 2026-04-03*
*Ready for roadmap: yes*
