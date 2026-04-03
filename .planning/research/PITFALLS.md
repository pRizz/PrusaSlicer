# Pitfalls Research

**Domain:** Build and tooling modernization for a large brownfield C++ desktop application
**Researched:** 2026-04-03
**Confidence:** HIGH

## Critical Pitfalls

### Pitfall 1: Permanent Dual Authority

**What goes wrong:**
The repo keeps both the legacy build and the new build as long-term "real" paths, and contributors stop knowing which one defines truth.

**Why it happens:**
Teams want to reduce migration risk, so they never set an explicit cutoff.

**How to avoid:**
Define parity gates and a deprecation plan early. Temporary overlap is allowed, but every overlapping area must have an owner and an exit condition.

**Warning signs:**
Docs say "either build system works," CI still relies on the legacy path, or new work lands only in the old build definitions.

**Phase to address:**
Phase 1: evaluation and migration policy

---

### Pitfall 2: Translating the Old Build Without Simplifying It

**What goes wrong:**
The new build graph becomes a syntax-level port of today's CMake complexity, custom probes, and vendoring habits.

**Why it happens:**
One-to-one translation feels safer than rethinking ownership and dependency boundaries.

**How to avoid:**
Use the migration to simplify target boundaries, centralize toolchains, and document dependency provenance. Port behavior, not historical accidents.

**Warning signs:**
Most new definitions are giant compatibility wrappers, custom probes reappear under new names, and `third_party` ownership remains opaque.

**Phase to address:**
Phase 2: authoritative graph skeleton and dependency strategy

---

### Pitfall 3: Bridging Too Much for Too Long

**What goes wrong:**
Bridge layers like `rules_foreign_cc` become the dominant architecture, so the new build still depends on the old tooling for the hardest parts.

**Why it happens:**
Bridge rules are useful and fast, so teams stop after the first successful build.

**How to avoid:**
Use bridges only for explicitly temporary islands. Track them in a migration inventory and retire them as native ownership becomes practical.

**Warning signs:**
Critical app targets still transitively depend on CMake wrappers months into the migration, or nobody can explain what remains native versus bridged.

**Phase to address:**
Phase 3: dependency migration and native ownership

---

### Pitfall 4: Treating Editor Support as Optional

**What goes wrong:**
The build passes, but contributors lose `clangd`, indexing, diagnostics, or predictable formatting/linting behavior.

**Why it happens:**
Teams optimize for green CI first and assume developer ergonomics can come later.

**How to avoid:**
Make compile metadata, formatter/linter availability, and editor instructions part of the first authoritative milestone.

**Warning signs:**
Contributors keep generating compile commands from the legacy build, editor setup docs fork by platform, or linting works only in CI.

**Phase to address:**
Phase 4: tooling and contributor UX

---

### Pitfall 5: CI Green, Local Repro Broken

**What goes wrong:**
The new path appears healthy in CI, but local development still depends on undocumented system libraries, path assumptions, or machine-specific tools.

**Why it happens:**
CI gets treated as the product instead of a verification of the contributor workflow.

**How to avoid:**
Use the same authoritative targets locally and in CI, keep system-library exceptions narrow and documented, and validate on fresh Linux/macOS environments.

**Warning signs:**
A clean checkout on a second machine needs extra tribal-knowledge steps, or CI workflows contain logic not described anywhere for contributors.

**Phase to address:**
Phase 5: CI hardening and reproducibility verification

---

### Pitfall 6: Pulling Packaging and Windows Too Early

**What goes wrong:**
The migration scope explodes into platform-specific release issues before Linux/macOS authority is proven.

**Why it happens:**
Teams confuse completeness with sequencing.

**How to avoid:**
Keep the first authoritative milestone focused: Linux/macOS builds, tests, tooling, and CI. Defer Windows and deeper packaging parity intentionally.

**Warning signs:**
Roadmap phases start centering Windows SDK quirks or release packaging before core contributor workflows are stable.

**Phase to address:**
Phase 1: scope control and roadmap definition

## Technical Debt Patterns

Shortcuts that seem reasonable but create long-term problems.

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Keep using the legacy build to generate editor metadata | Fastest way to restore IDE support | Preserves hidden dependency on the old build and delays authority | Only as a very short-lived bootstrap with an explicit removal task |
| Wrap every dependency through a foreign-build bridge | Fast path to "it builds" | Leaves the new graph opaque and fragile | Acceptable only for hard legacy islands with tracked retirement |
| Enable broad lint rules immediately | Looks modern and strict | Creates noisy churn and slows migration progress | Rarely; better to ratchet from a narrow baseline |
| Leave system-library fallbacks undocumented | Makes one machine work quickly | Reproducibility erodes and CI/local divergence grows | Never |
| Keep release packaging in legacy scripts indefinitely | Avoids a hard packaging problem | Prevents the new build from fully owning the release story | Acceptable only until core Linux/macOS authority is proven |

## Integration Gotchas

Common mistakes when connecting to external services.

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| GitHub Actions | CI runs different commands than contributors use locally | Invoke the same authoritative targets in both environments |
| LLVM tooling | `clang-format`, `clang-tidy`, and `clangd` versions drift by platform | Pin one LLVM release line and document acquisition |
| Source-fetched dependencies | Dependency origin, patching, and override logic live in scattered scripts | Centralize provenance, patches, and exceptions in one ownership layer |
| Legacy dependency bridges | Hidden CMake/configure assumptions leak into the new graph | Document every bridge, its inputs, and its retirement criteria |

## Performance Traps

Patterns that work at small scale but fail as migration usage grows.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Over-broad top-level targets | Slow local iteration, frequent cache misses, hard-to-reason CI failures | Create narrow, composable product and validation targets | Once contributors use the build daily |
| Unbounded lint targets | Long feedback loops and frequent avoidance of tooling | Start with targeted lint scopes and staged enforcement | As soon as the repo has meaningful warning debt |
| Dependency graph opacity | Hard-to-diagnose rebuilds and ownership confusion | Keep `third_party` definitions explicit and inspectable | When more than a handful of dependencies are migrated |
| CI-only cache assumptions | Fast CI, slow or flaky local builds | Design for local correctness first, then optimize caches | Once multiple developers rely on the build |

## Security Mistakes

Domain-specific security issues beyond general app security.

| Mistake | Risk | Prevention |
|---------|------|------------|
| Unpinned tool and dependency downloads | Non-reproducible builds, supply-chain ambiguity | Pin versions, checksums, and provenance in the authoritative build metadata |
| Over-broad CI action trust | Supply-chain exposure in the new CI path | Pin third-party actions and keep permissions narrow |
| Reusing opaque vendored blobs without provenance cleanup | Harder auditing and upgrade risk | Track source origins, patches, and update paths explicitly |

## UX Pitfalls

Common user experience mistakes in this domain.

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| "Works, but only if you already know the old build" | New contributors still feel blocked | Make the new path self-contained in docs and commands |
| Different commands for Linux and macOS without clear rationale | Contributors assume the build is fragile | Keep one primary workflow with documented platform deltas |
| Build success without actionable failure messages | Contributors abandon the new path quickly | Surface narrow targets, clear docs, and explicit dependency ownership |

## "Looks Done But Isn't" Checklist

- [ ] **Authoritative build:** The app compiles, but tests still only run through the legacy build — verify core suites run from the new path
- [ ] **Dependency migration:** Dependencies are fetched, but provenance and overrides are not documented — verify `third_party` ownership is explicit
- [ ] **Editor support:** The repo builds, but `clangd` still needs legacy compile commands — verify editor setup uses the authoritative path
- [ ] **CI parity:** Linux is green, macOS is still manual or legacy-only — verify both first-class platforms are enforced in CI
- [ ] **Authority cutoff:** Docs mention the new build, but contributors still default to CMake — verify the documented entry point has changed

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Permanent dual authority | HIGH | Freeze new work in legacy build files, define cutoff gates, and delete duplicated paths once parity is proven |
| Overused bridge layers | MEDIUM | Inventory bridge-owned targets, prioritize native replacement by impact, and retire the worst offenders first |
| Poor editor support | MEDIUM | Add compile metadata generation, pin LLVM tools, and update contributor docs immediately |
| CI/local divergence | MEDIUM | Rebuild CI around local commands, document environment assumptions, and test from fresh machines |
| Scope explosion into Windows/packaging | HIGH | Re-baseline roadmap to Linux/macOS authority first and move deferred work to later phases |

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Permanent dual authority | Phase 1 | Legacy overlap has explicit cutoff gates and owners |
| Syntax-level CMake translation | Phase 2 | New graph reflects product boundaries and dependency strategy, not just old macro structure |
| Bridge layers becoming permanent | Phase 3 | Bridge inventory shrinks and critical targets gain native ownership |
| Editor support afterthought | Phase 4 | Contributors can use formatting, linting, and `clangd` without legacy steps |
| CI/local divergence | Phase 5 | Linux/macOS CI runs the same authoritative targets documented for local use |
| Windows/packaging too early | Phase 1 and later roadmap control | Deferred scope stays deferred until authority is proven |

## Sources

- `.planning/PROJECT.md` — migration scope and constraints
- `.planning/codebase/CONCERNS.md` — current repo fragility and build/dependency pain points
- `.planning/research/STACK.md` — stack recommendations and version guidance
- https://bazel.build/docs — build graph and migration documentation
- https://bazel.build/docs/bzlmod — dependency system expectations
- https://mesonbuild.com/Dependencies.html — dependency-handling tradeoffs
- https://mesonbuild.com/Subprojects.html — subproject migration tradeoffs
- https://clangd.llvm.org/installation.html — editor support expectations
- https://docs.github.com/en/actions/automating-your-workflow-with-github-actions — CI automation guidance
- https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs — multi-platform matrix guidance

---
*Pitfalls research for: brownfield C++ build/tooling modernization*
*Researched: 2026-04-03*
