# Requirements: PrusaSlicer Build Stack Modernization

**Defined:** 2026-04-03
**Core Value:** Maintainers and contributors can build, test, and work on PrusaSlicer through a simple, repeatable, authoritative toolchain on Linux and macOS.

## v1 Requirements

### Evaluation

- [x] **EVAL-01**: Maintainers can compare Bazel and Meson + Ninja against documented migration criteria for PrusaSlicer
- [x] **EVAL-02**: Maintainers can record one authoritative build-system decision with rationale and explicit rejection criteria for the non-selected option
- [x] **EVAL-03**: Maintainers can define parity gates and an authority cutoff plan before long-term migration work proceeds

### Build

- [ ] **BLD-01**: Contributor can build the PrusaSlicer application on Linux through the authoritative build path
- [ ] **BLD-02**: Contributor can build the PrusaSlicer application on macOS through the authoritative build path
- [x] **BLD-03**: Contributor can run one documented authoritative command surface instead of choosing between competing primary build workflows
- [ ] **BLD-04**: Contributor can run the core automated test suites through the authoritative build path on Linux and macOS

### Dependencies

- [ ] **DEPS-01**: Maintainer can declare third-party dependencies through explicit, version-pinned, reproducible metadata in the new build stack
- [x] **DEPS-02**: Maintainer can allow selected system-library exceptions only when they are documented with rationale and scope
- [ ] **DEPS-03**: Maintainer can track temporary legacy-build bridges with clear ownership and retirement criteria

### Tooling

- [ ] **TOOL-01**: Contributor can run repository formatting through the authoritative toolchain with documented expectations
- [ ] **TOOL-02**: Contributor can run an initial lint/static-analysis pass through the authoritative toolchain without relying on the legacy build
- [ ] **TOOL-03**: Contributor can use `clangd` or equivalent editor metadata without generating build information from the legacy build
- [ ] **TOOL-04**: Contributor can follow one maintained setup guide for Linux and macOS build, test, format, lint, and editor workflows

### CI

- [ ] **CI-01**: Maintainer can run Linux CI jobs against the same authoritative build and test targets used locally
- [ ] **CI-02**: Maintainer can run macOS CI jobs against the same authoritative build and test targets used locally
- [ ] **CI-03**: Maintainer can verify that the authoritative path, not the legacy build, is the gate for new build/test/tooling changes

## v2 Requirements

### Platform Expansion

- **PLAT-01**: Contributor can build the authoritative path on Windows
- **PLAT-02**: Maintainer can validate Windows CI on the authoritative path

### Release and Packaging

- **PKG-01**: Maintainer can produce release-packaging artifacts from the authoritative build path
- **PKG-02**: Maintainer can replace remaining legacy packaging glue with documented authoritative targets

### Tooling Expansion

- **TOOL-05**: Contributor can run sanitizer-enabled profiles through the authoritative build path
- **TOOL-06**: Maintainer can ratchet `clang-tidy` policy beyond the initial baseline without drowning the migration in pre-existing warning debt

### Dependency Deepening

- **DEPS-04**: Maintainer can replace high-value legacy bridge layers with native ownership in the selected build system

## Out of Scope

| Feature | Reason |
|---------|--------|
| New end-user slicer capabilities | This project is strictly build/tooling migration work |
| Windows in the first authoritative milestone | Linux and macOS are the chosen first-class migration targets |
| Perfect parity for obsolete or low-value legacy edges | The user explicitly allows sensible deferral where preserving dead weight would slow the migration |
| Permanent dual maintenance of CMake and the new build stack | Temporary overlap is acceptable, but one authoritative path is the goal |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| EVAL-01 | Phase 1 | Complete |
| EVAL-02 | Phase 1 | Complete |
| EVAL-03 | Phase 1 | Complete |
| BLD-01 | Phase 3 | Pending |
| BLD-02 | Phase 3 | Pending |
| BLD-03 | Phase 2 | Complete |
| BLD-04 | Phase 4 | Pending |
| DEPS-01 | Phase 3 | Pending |
| DEPS-02 | Phase 2 | Complete |
| DEPS-03 | Phase 3 | Pending |
| TOOL-01 | Phase 4 | Pending |
| TOOL-02 | Phase 4 | Pending |
| TOOL-03 | Phase 4 | Pending |
| TOOL-04 | Phase 5 | Pending |
| CI-01 | Phase 5 | Pending |
| CI-02 | Phase 5 | Pending |
| CI-03 | Phase 5 | Pending |

**Coverage:**
- v1 requirements: 17 total
- Mapped to phases: 17
- Unmapped: 0 ✓

---
*Requirements defined: 2026-04-03*
*Last updated: 2026-04-04 after Phase 1 completion*
