# Feature Research

**Domain:** Build and tooling modernization for a large brownfield C++ desktop application
**Researched:** 2026-04-03
**Confidence:** HIGH

## Feature Landscape

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = the migration is not credible.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Authoritative build entry point | Maintainers expect one documented command surface, not competing "real" build paths | HIGH | This is the center of the entire project. Transitional overlap is acceptable; permanent dual authority is not. |
| Reproducible dependency resolution | A modern build migration is expected to reduce "works on my machine" behavior | HIGH | Source-fetched dependencies with pinned provenance are the default expectation; selected system-library exceptions must be explicit. |
| Linux and macOS app builds | These are the first-class migration targets the user named | HIGH | A migration that cannot produce real app builds on both platforms is not yet authoritative. |
| Test execution under the new build | Existing Catch2/CTest-based quality signals must survive the migration | MEDIUM | Test coverage does not need to be perfect on day one, but core suites must run reliably. |
| Editor and compiler tooling support | Contributors expect `clangd`, formatting, and linting to work with the chosen build graph | MEDIUM | This is especially important if Bazel is chosen, because poor editor ergonomics will create immediate pushback. |
| CI for the new path | A modern build stack must be enforced in automation, not only on a maintainer laptop | MEDIUM | Linux/macOS matrix coverage is table stakes for authority. |

### Differentiators (Competitive Advantage)

Features that make the modernization effort materially better than a routine build rewrite.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Explicit evaluation phase for Bazel vs Meson | Prevents ideology from locking the repo into the wrong tool | MEDIUM | This is a project-level differentiator because it turns build-system selection into a falsifiable decision. |
| Lockfile-driven dependency provenance | Makes upgrades, auditing, and rollback clearer than today's mixed vendoring/custom-find story | HIGH | Especially valuable if Bazel + Bzlmod wins. |
| Gradual legacy bridge with an explicit cutoff | Lets the repo reach real usefulness before every edge is migrated, without normalizing long-term duplication | HIGH | `rules_foreign_cc` or equivalent should be treated as temporary scaffolding, not the architecture. |
| Standardized LLVM/Clang tooling spine | Unifies formatting, linting, indexing, and sanitizer behavior around one release line | MEDIUM | This reduces tool drift and gives contributors a coherent dev environment. |
| Build graph observability | Ability to inspect dependency graphs, CI failures, and target ownership improves maintainability | MEDIUM | Bazel is stronger here than Meson, but both should expose enough structure to make the build understandable. |

### Anti-Features (Commonly Requested, Often Problematic)

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Permanent dual build systems | Feels safer because nothing ever gets removed | Splits maintenance attention, causes drift, and prevents the new path from becoming authoritative | Use a time-boxed transition with explicit parity gates and a removal point |
| Full dependency rewrite before first green build | Feels "clean" | Delays proof of value and makes the migration too risky | Bridge difficult dependencies first, then replace bridges with native ownership over time |
| Windows in the first authoritative milestone | Feels complete | Increases migration complexity sharply before Linux/macOS authority is earned | Defer Windows intentionally and document it as v2 work |
| Aggressive lint enforcement from day one | Feels like modernization | Can bury the migration in pre-existing warning noise and non-goal source churn | Start with formatting plus a narrow `clang-tidy` baseline, then ratchet |
| Reproducing every obsolete edge for parity | Feels safer | Lets dead-weight compatibility dominate the roadmap | Preserve high-value paths and explicitly defer obsolete/low-value edges |

## Feature Dependencies

```text
Tool evaluation
    └──requires──> migration success criteria
                          └──requires──> Linux/macOS build parity target

Authoritative build path
    ├──requires──> dependency model
    ├──requires──> toolchain standardization
    └──requires──> target ownership boundaries

Editor support ──requires──> accurate compile metadata / graph introspection
Test execution ──requires──> authoritative build targets
CI authority ──requires──> build + test + tooling targets
Packaging migration ──enhances──> authoritative build path
Windows support ──depends-on-later──> stable Linux/macOS authority
```

### Dependency Notes

- **Tool evaluation requires migration success criteria:** Without explicit decision criteria, Bazel vs Meson becomes opinion instead of engineering.
- **Authoritative build path requires dependency and toolchain decisions:** The repo cannot be authoritative if it still delegates most critical work to opaque legacy logic.
- **Editor support requires accurate build metadata:** Contributors will reject a migration that builds but breaks navigation, indexing, or diagnostics.
- **CI authority requires the same real targets used locally:** Separate "CI-only" build logic recreates the same drift the migration is trying to remove.
- **Windows support depends on stable Linux/macOS authority:** Deferring Windows is a sequencing choice, not a rejection of support.

## MVP Definition

### Launch With (v1)

- [ ] Evaluate Bazel and Meson against explicit migration criteria and choose one authoritative direction — this prevents a bad tool decision from poisoning the roadmap
- [ ] Build the PrusaSlicer application and core tests on Linux and macOS through the new path — this proves the migration is real
- [ ] Establish mostly source-fetched dependency handling with documented exceptions — this addresses repeatability directly
- [ ] Provide `clang-format`, initial `clang-tidy`, and usable `clangd`/editor support — this makes the new path workable for contributors
- [ ] Run Linux and macOS CI against the same authoritative targets — this makes the new path enforceable

### Add After Validation (v1.x)

- [ ] Migrate more third-party ownership from bridge wrappers to native build definitions — once the authoritative path is stable, reduce transitional complexity
- [ ] Add sanitizer profiles and stronger lint policies — once base builds are trusted, expand correctness checks
- [ ] Replace more release and packaging steps with the new build path — once the core authority is earned, absorb adjacent legacy flows

### Future Consideration (v2+)

- [ ] Windows migration under the new authoritative build — defer until Linux/macOS prove the architecture
- [ ] Full release-packaging parity and niche legacy-path migration — only after core contributor workflows are solid
- [ ] Deeper dependency de-vendoring where the maintenance payoff is proven — do not force this ahead of build authority

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Tool evaluation with explicit criteria | HIGH | MEDIUM | P1 |
| Linux/macOS authoritative app build | HIGH | HIGH | P1 |
| Core test execution | HIGH | MEDIUM | P1 |
| Reproducible dependency model | HIGH | HIGH | P1 |
| `clangd` / compile metadata support | HIGH | MEDIUM | P1 |
| Formatting + initial linting | MEDIUM | LOW | P1 |
| CI matrix for Linux/macOS | HIGH | MEDIUM | P1 |
| Sanitizer profiles | MEDIUM | MEDIUM | P2 |
| Packaging migration | MEDIUM | HIGH | P2 |
| Windows migration | MEDIUM | HIGH | P3 |

**Priority key:**
- P1: Must have for launch
- P2: Should have, add when possible
- P3: Nice to have, future consideration

## Competitor Feature Analysis

| Feature | Bazel-centered approach | Meson-centered approach | Our Approach |
|---------|-------------------------|-------------------------|--------------|
| Dependency model | Strongest graph-level dependency ownership and pinning | Simpler dependency ergonomics with wraps/subprojects, but weaker graph uniformity | Prefer Bazel if the repo can absorb the rule ownership cost |
| Contributor UX | Excellent once stable, but can be rough during migration without good editor support and macros | Often easier to adopt for existing C/C++ contributors | Make contributor ergonomics a go/no-go criterion, not an afterthought |
| Transitional legacy bridging | Strong via bridge rules, but dangerous if overused | Easier to mix with legacy build conventions, but can preserve old complexity | Allow bridges only as staged migration aids |
| CI and repeatability | Strongest fit for the stated goals | Good but usually less opinionated and less hermetic | Use CI repeatability as one of the decision criteria |

## Sources

- `.planning/PROJECT.md` — migration goals, scope, and constraints
- `.planning/codebase/STACK.md` — current repo stack and dependency reality
- `.planning/codebase/ARCHITECTURE.md` — current product boundaries to preserve
- https://bazel.build/docs — Bazel build and migration documentation
- https://bazel.build/docs/bzlmod — Bazel dependency model
- https://mesonbuild.com/Dependencies.html — Meson dependency handling
- https://mesonbuild.com/Subprojects.html — Meson subproject model
- https://mesonbuild.com/Wrap-dependency-system-manual.html — Meson wrap dependency system
- https://clangd.llvm.org/installation.html — clangd/editor expectations
- https://clang.llvm.org/docs/ClangFormat.html — formatting workflow expectations
- https://clang.llvm.org/extra/clang-tidy/index.html — linting workflow expectations
- https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs — CI matrix guidance

---
*Feature research for: brownfield C++ build/tooling modernization*
*Researched: 2026-04-03*
