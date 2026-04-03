# Stack Research

**Domain:** Brownfield modernization of a large cross-platform C++ desktop application's build and tooling stack
**Researched:** 2026-04-03
**Confidence:** HIGH

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Bazel | 9.0.1 LTS | Authoritative build graph, dependency resolution, caching, CI/build orchestration | Best fit for the stated goals of repeatability, reliability, and explicit dependency modeling. Bazel 9 is the current active LTS line, and Bzlmod is now the dependency system rather than a side path. |
| Bzlmod (`MODULE.bazel`) | Bazel 9 era | External dependency management and lockfile-driven module resolution | This is Bazel's modern dependency story and the main reason Bazel is compelling for this migration. It replaces the legacy `WORKSPACE` flow and gives direct-dependency declarations, overrides, and lockfiles. |
| LLVM/Clang toolchain | 22.1.x | Primary compiler, `clangd`, `clang-format`, `clang-tidy`, sanitizers | A single LLVM release line keeps compile, editor, formatting, linting, and sanitizer behavior aligned. This reduces tool drift and is the cleanest modern C/C++ tooling baseline. |
| Ninja-backed execution model | Built into Bazel/Meson workflows | Fast local builds and clear action graphs | Both Bazel and Meson lean on Ninja-style incremental execution patterns. This improves local iteration time without making Ninja the source of truth. |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `rules_cc` | Current BCR-compatible release for Bazel 9 | Core Bazel C/C++ rules support | Use when Bazel is selected as the authoritative build system. Treat it as foundational, not optional. |
| `rules_foreign_cc` | 0.13.0 | Transitional bridge for dependencies or subtrees that still build through CMake, Meson, configure, or Make | Use during migration when parts of the dependency graph are too expensive to rewrite as native Bazel rules immediately. Remove or shrink its footprint over time. |
| Meson | 1.10.0 | Fallback build system if Bazel proves too costly for this codebase | Use only if the Bazel evaluation phase concludes that native Bazel ownership is too painful for PrusaSlicer's dependency and desktop-app reality. |
| WrapDB / Meson subprojects | Meson 1.10 era | Mostly source-fetched dependency acquisition for a Meson-based fallback | Use if Meson becomes the selected path and the project still wants explicit source-fetched dependencies with some system-library escape hatches. |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| `clang-format` | Consistent formatting | Keep a repo-root `.clang-format` and prefer format-on-touched-lines or target-specific formatting in CI. |
| `clang-tidy` | Static analysis and policy linting | Requires a compile command database or equivalent build-integrated invocation. Start with a small enforced rule set and expand after warnings are made tractable. |
| `clangd` | Editor/LSP support | Treat editor metadata generation as a first-class requirement. Poor editor support is one of the fastest ways to lose contributor trust in a new build stack. |
| AddressSanitizer / UndefinedBehaviorSanitizer / ThreadSanitizer | Runtime validation | Add these as opt-in or CI-targeted profiles, not the default developer build, to keep the baseline fast while still exposing correctness issues. |
| Bazelisk | Bazel version management | Recommended if Bazel is selected, so contributors do not manually manage Bazel versions. Keep the repo-pinned version explicit. |

## Installation

```bash
# Bazel-first path
brew install bazelisk llvm   # macOS example
# or install bazelisk + LLVM packages through the distro package manager on Linux

# Repository root
cat > MODULE.bazel <<'EOF'
module(name = "prusaslicer")
EOF

# Meson fallback path
python3 -m pip install --user meson==1.10.0 ninja
```

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Bazel 9 + Bzlmod | Meson 1.10 + Ninja | Use Meson if the Bazel evaluation phase shows that native rule ownership, desktop-app packaging, or third-party integration cost is too high for this repo. |
| LLVM/Clang 22.1.x | GCC-centered tooling | Use GCC as a secondary compiler in validation matrices, but not as the primary tooling spine if the goal is unified formatting, linting, LSP, and sanitizer workflows. |
| Native Bazel rules over time | Long-term `rules_foreign_cc` dependence | Use `rules_foreign_cc` only as a migration aid. If it remains the dominant integration layer, Bazel will inherit much of the old build complexity instead of replacing it. |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| New long-lived `WORKSPACE`-based Bazel setup | Bazel 9 has removed support for the legacy `WORKSPACE` dependency model | Use `MODULE.bazel` and Bzlmod |
| A permanent dual-source-of-truth build world | Maintaining CMake and Bazel/Meson indefinitely defeats the authoritative-build goal | Use a staged migration with an explicit cutoff to one primary system |
| Unpinned toolchain drift across formatting, linting, and editor tooling | Mismatched tool versions cause noisy diagnostics and contributor confusion | Pin one LLVM/Clang release line across `clang-format`, `clang-tidy`, `clangd`, and sanitizer-enabled builds |
| Recreating opaque vendoring by hand inside the new build | This preserves the current maintenance burden under a different syntax | Use explicit source-fetched modules/subprojects with documented overrides and narrow system-lib exceptions |

## Stack Patterns by Variant

**If Bazel wins the evaluation:**
- Use Bazel 9.0.1 LTS as the authoritative build entry point
- Use Bzlmod via `MODULE.bazel` and lockfiles for direct dependency declarations
- Use `rules_foreign_cc` only to bridge hard-to-migrate third-party or legacy build islands
- Standardize on LLVM/Clang 22.1.x for compile, lint, formatting, editor support, and sanitizers

**If Meson wins the evaluation:**
- Use Meson 1.10.0 with Ninja as the authoritative build entry point
- Use Meson wraps/subprojects for mostly source-fetched dependencies, allowing selected system libraries
- Still standardize on LLVM/Clang 22.1.x for compiler-adjacent tooling
- Accept that dependency reproducibility and graph uniformity will be weaker than the Bazel option

## Version Compatibility

| Package A | Compatible With | Notes |
|-----------|-----------------|-------|
| Bazel 9.0.1 | Bzlmod-only dependency flow | Treat Bzlmod as mandatory, not optional, because `WORKSPACE` is no longer the forward path in Bazel 9. |
| Bazel 9.0.1 | `rules_foreign_cc` 0.13.0 | `rules_foreign_cc` documents compatibility with Bazel after 5.4.0, but the migration should validate it explicitly on the selected Bazel 9 line. |
| LLVM/Clang 22.1.x | `clangd`, `clang-format`, `clang-tidy`, sanitizers from the same release line | Keep these tools on the same LLVM release to avoid diagnostics and indexing skew. |
| Meson 1.10.0 | Wrap dependency system / subprojects | Suitable if the fallback path needs mostly source-fetched dependencies with some system-library escape hatches. |

## Sources

- https://bazel.build/release/versioning — verified Bazel support matrix and current active LTS line
- https://blog.bazel.build/2026/01/20/bazel-9.html — verified Bazel 9 and Bzlmod replacing the legacy `WORKSPACE` system
- https://bazel.build/docs/bzlmod — verified the current external dependency model and `MODULE.bazel` workflow
- https://github.com/bazel-contrib/rules_foreign_cc/releases — verified current `rules_foreign_cc` release line
- https://github.com/bazel-contrib/rules_foreign_cc — verified the role of `rules_foreign_cc` as a bridge to foreign build systems
- https://mesonbuild.com/Release-notes.html — verified current Meson stable release series and in-development next release
- https://mesonbuild.com/Release-notes-for-1-10-0.html — verified Meson 1.10.0 release details
- https://mesonbuild.com/Subprojects.html — verified Meson subproject support
- https://mesonbuild.com/Wrap-dependency-system-manual.html — verified Meson's wrap dependency system
- https://llvm.org/ — verified current LLVM release line availability
- https://releases.llvm.org/22.1.0/tools/clang/docs/ReleaseNotes.html — verified current stable Clang 22.1.0 release notes
- https://clang.llvm.org/extra/clang-tidy/index.html — verified current clang-tidy usage expectations
- https://clang.llvm.org/docs/ClangFormat.html — verified current clang-format documentation
- https://clangd.llvm.org/installation.html — verified clangd installation and editor integration guidance
- https://releases.llvm.org/22.1.0/tools/clang/docs/ThreadSanitizer.html — verified current sanitizer documentation line

---
*Stack research for: brownfield C++ build/tooling modernization*
*Researched: 2026-04-03*
