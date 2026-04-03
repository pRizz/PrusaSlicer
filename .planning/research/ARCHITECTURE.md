# Architecture Research

**Domain:** Build and tooling modernization for a large brownfield C++ desktop application
**Researched:** 2026-04-03
**Confidence:** HIGH

## Standard Architecture

### System Overview

```text
┌──────────────────────────────────────────────────────────────────────┐
│                    Evaluation and Policy Layer                      │
├──────────────────────────────────────────────────────────────────────┤
│  tool selection   migration criteria   parity gates   docs/owners   │
└──────────────┬───────────────────────────────────────────────────────┘
               │
┌──────────────▼───────────────────────────────────────────────────────┐
│                  Authoritative Build Definition Layer               │
├──────────────────────────────────────────────────────────────────────┤
│  BUILD/MODULE files or meson.build files   repo macros   platforms  │
└──────────────┬───────────────────────────────────────────────────────┘
               │
┌──────────────▼───────────────────────────────────────────────────────┐
│                Toolchain and Dependency Resolution Layer            │
├──────────────────────────────────────────────────────────────────────┤
│  LLVM/Clang toolchain   source-fetched deps   selected system libs  │
│  transition bridges for hard legacy islands                         │
└──────────────┬───────────────────────────────────────────────────────┘
               │
┌──────────────▼───────────────────────────────────────────────────────┐
│                Product Targets and Validation Layer                 │
├──────────────────────────────────────────────────────────────────────┤
│  app build   test targets   format/lint   compile metadata   CI     │
└──────────────┬───────────────────────────────────────────────────────┘
               │
┌──────────────▼───────────────────────────────────────────────────────┐
│                    Legacy Boundary and Exit Layer                   │
├──────────────────────────────────────────────────────────────────────┤
│  temporary CMake bridges   deferred packaging   deferred Windows    │
└──────────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Typical Implementation |
|-----------|----------------|------------------------|
| Evaluation policy | Defines success criteria for choosing Bazel vs Meson and for declaring the new path authoritative | ADR-style docs, parity checklist, migration scorecard |
| Build definition layer | Declares targets, dependencies, visibility, and platform conditions | `MODULE.bazel` + `BUILD.bazel` + macros, or `meson.build` + wraps if Meson wins |
| Toolchain layer | Pins compiler, linker, formatter, linter, and sanitizer behavior | Central LLVM/Clang configuration and platform-specific toolchain declarations |
| Dependency layer | Owns source-fetched third-party inputs, patching, overrides, and explicit system-lib exceptions | Bzlmod modules / archive rules or Meson subprojects + wraps |
| Validation layer | Runs app builds, tests, linting, formatting, editor metadata generation, and CI jobs | First-class build targets and CI workflows using the same commands as local dev |
| Legacy boundary | Tracks what still depends on old tooling and under what exit criteria | Temporary bridge rules, documented exceptions, explicit deprecation timeline |

## Recommended Project Structure

```text
.
├── MODULE.bazel / meson.build   # authoritative build entry point
├── BUILD.bazel                  # root targets if Bazel wins
├── bazel/ or build/             # repo macros, transitions, helper definitions
│   ├── toolchains/              # LLVM/Clang and platform toolchain config
│   ├── platforms/               # linux/macos constraints and config settings
│   ├── lint/                    # clang-format, clang-tidy, sanitizer policy
│   └── docs/                    # migration conventions and target ownership notes
├── third_party/                 # dependency wrappers, metadata, patches, overrides
│   ├── README.md                # provenance and update rules
│   └── [dep]/                   # per-dependency ownership
├── src/                         # product source targets
├── tests/                       # test targets grouped by suite
├── ci/ or .github/workflows/    # matrix and validation workflows
├── docs/build/                  # contributor entry points and migration guide
└── legacy/notes/                # temporary migration inventory and cutoff tracking
```

### Structure Rationale

- **Root authoritative files:** The chosen build system must be visibly real at repo root, not hidden as an experimental sidecar.
- **`toolchains/` and `platforms/`:** Toolchain pinning and platform branching must be centralized so Linux/macOS behavior is understandable and reviewable.
- **`third_party/`:** Dependency provenance, patches, and exceptions need one obvious home instead of being split across `deps/`, custom find modules, and undocumented scripts.
- **`docs/build/`:** Contributor trust depends on a single maintained entry point for build, test, lint, and troubleshooting.

## Architectural Patterns

### Pattern 1: Authoritative Overlay First

**What:** Introduce the new build system as a top-level authoritative overlay over the existing source tree rather than rewriting source layout immediately.
**When to use:** Early and middle migration phases.
**Trade-offs:** Faster to prove value; can temporarily feel duplicative until legacy build definitions are retired.

**Example:**
```text
src/libslic3r/...        # existing source tree
tests/...                # existing test tree
third_party/...          # new dependency ownership metadata
BUILD.bazel              # target graph overlay
```

### Pattern 2: Bridge the Hard Islands, Do Not Normalize Them

**What:** Use foreign-build bridges only for dependencies or subtrees that are too expensive to rewrite immediately.
**When to use:** For third-party or packaging islands that would otherwise block authority.
**Trade-offs:** Improves delivery speed, but every bridge kept too long preserves legacy complexity.

**Example:**
```text
native targets
    └──temporary bridge──> legacy dependency build
                               └──cutoff criteria documented
```

### Pattern 3: Validation as First-Class Targets

**What:** Treat tests, formatting, linting, editor metadata, and sanitizer profiles as build targets, not loose scripts.
**When to use:** As soon as the new build graph can compile meaningful code.
**Trade-offs:** Slightly more up-front structure, much better long-term repeatability and CI parity.

## Data Flow

### Request Flow

```text
[Contributor or CI]
    ↓
[Authoritative command]
    ↓
[Target graph resolution]
    ↓
[Toolchain selection + dependency resolution]
    ↓
[Compile / link / test / lint / metadata generation]
    ↓
[Local artifacts, diagnostics, CI status]
```

### State Management

```text
[Version-pinned toolchain + dependency declarations]
    ↓
[Build definitions]
    ↓
[Generated artifacts and metadata]
    ↓
[CI + contributor workflows]
```

### Key Data Flows

1. **Build graph flow:** source targets and third-party targets resolve through one authoritative graph into app artifacts and tests.
2. **Tooling flow:** the same authoritative graph produces formatting/linting coverage and the metadata contributors need for `clangd`.
3. **CI flow:** GitHub Actions invokes the same authoritative targets used locally across Linux and macOS.
4. **Migration flow:** deferred legacy paths remain behind explicit bridge points with tracked exit criteria.

## Scaling Considerations

| Scale | Architecture Adjustments |
|-------|--------------------------|
| Evaluation and first authority | Keep scope to Linux/macOS app build, core tests, and contributor tooling |
| Broader dependency migration | Replace bridge-owned dependencies with native build ownership and tighten lint/sanitizer policies |
| Full ecosystem authority | Absorb packaging/release paths and later Windows support after Linux/macOS authority is stable |

### Scaling Priorities

1. **First bottleneck:** dependency ownership and toolchain consistency. Fix by centralizing toolchains and moving third-party metadata into an explicit ownership layer.
2. **Second bottleneck:** contributor UX. Fix by treating editor metadata, docs, and CI parity as non-optional architecture components.

## Anti-Patterns

### Anti-Pattern 1: Translating CMake One-to-One

**What people do:** Recreate the existing CMake graph mechanically in the new system.
**Why it's wrong:** It preserves old layering mistakes and custom dependency complexity under a new syntax.
**Do this instead:** Rebuild target ownership around product boundaries and migration goals, not around current macro structure.

### Anti-Pattern 2: Hiding Authority Behind Scripts

**What people do:** Keep the real build system buried under wrapper scripts and undocumented conventions.
**Why it's wrong:** Contributors cannot reason about the build graph or fix it confidently.
**Do this instead:** Make the authoritative entry point and ownership model obvious at repo root and in contributor docs.

### Anti-Pattern 3: Making Editor Support Optional

**What people do:** Defer `clangd` and compile metadata until after the build "works."
**Why it's wrong:** Contributors perceive the migration as regression-heavy even if builds pass.
**Do this instead:** Include editor/tooling metadata in the first authoritative milestone.

## Integration Points

### External Services

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| GitHub Actions | Linux/macOS build and test matrix invoking authoritative targets | Use matrix jobs and pin third-party actions where possible |
| Dependency sources / registries | Source-fetched modules, archives, or wraps with explicit provenance | Track patches and system-lib exceptions in-repo |
| LLVM toolchain distribution | Version-pinned compiler and tool binaries for local and CI use | Keep formatter, linter, and language server on one release line |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| Product source ↔ build definitions | Explicit target declarations | Do not let build metadata sprawl into ad hoc scripts |
| Third-party ownership ↔ product targets | Wrapped dependency targets | Keep provenance and patching near the wrapper, not scattered |
| Validation targets ↔ CI workflows | Shared commands/targets | CI must not invent its own separate build truth |
| Legacy bridge ↔ authoritative graph | Temporary adapter boundary | Every bridge needs an exit condition |

## Sources

- `.planning/PROJECT.md` — project scope and success criteria
- `.planning/codebase/ARCHITECTURE.md` — current product structure that must survive migration
- `.planning/research/STACK.md` — recommended stack and version guidance
- https://bazel.build/docs — Bazel build model and migration documentation
- https://bazel.build/reference/glossary — Bazel graph terminology
- https://docs.bazel.build/versions/main/bazel-overview.html — Bazel dependency graph overview
- https://mesonbuild.com/Dependencies.html — Meson dependency handling
- https://mesonbuild.com/Subprojects.html — Meson subproject structure
- https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs — CI matrix structure
- https://clangd.llvm.org/installation.html — editor integration expectations

---
*Architecture research for: brownfield C++ build/tooling modernization*
*Researched: 2026-04-03*
