# Requirements: PrusaSlicer Build Stack Modernization

**Defined:** 2026-04-09
**Core Value:** Maintainers and contributors can build, test, and work on PrusaSlicer through a simple, repeatable, authoritative toolchain on Linux and macOS.

## v1.1 Requirements

Requirements for milestone `v1.1 Slice Deepening`. Each maps to exactly one roadmap phase.

### Execution

- [ ] **EXEC-01**: Contributor can run a real non-help PrusaSlicer CLI workflow through the authoritative Bazel path on macOS without the current legacy runtime handoff
- [ ] **EXEC-02**: Contributor can run the same Bazel-owned CLI workflow on Linux through the same authoritative public labels
- [ ] **EXEC-03**: Contributor can keep using the existing `./prusa` command surface and `//src:PrusaSlicer` label while the owned slice deepens

### Bridge Retirement

- [ ] **BRDG-01**: Maintainer can remove the current `//src:PrusaSlicer -> build/src/{Debug/,}PrusaSlicer|prusa-slicer` runtime handoff bridge
- [ ] **BRDG-02**: Maintainer can narrow or remove the temporary `src/BazelMain.cpp` entry shim so it no longer defines the primary execution path
- [ ] **BRDG-03**: Maintainer can track any remaining deep-slice bridges with explicit owner and retirement criteria

### Dependency Ownership

- [ ] **DEEP-01**: Maintainer can replace at least one high-value temporary dependency bridge in the deepened slice with explicit Bazel-owned or imported artifacts
- [ ] **DEEP-02**: Maintainer can keep macOS and Linux dependency exceptions for the deepened slice minimal, explicit, and reproducible

## Future Requirements

### Platform Expansion

- **PLAT-01**: Contributor can build the authoritative path on Windows
- **PLAT-02**: Maintainer can validate Windows CI on the authoritative path

### Release and Packaging

- **PKG-01**: Maintainer can produce release-packaging artifacts from the authoritative build path
- **PKG-02**: Maintainer can replace remaining legacy packaging glue with documented authoritative targets

### Validation and Tooling Expansion

- **VALD-01**: Maintainer can add Nyquist validation coverage for archived and active milestones without reopening shipped implementation scope
- **TOOL-05**: Maintainer can ratchet formatting and lint coverage beyond the current bounded surface without drowning in inherited warning debt

## Out of Scope

Explicitly excluded from milestone `v1.1 Slice Deepening`.

| Feature | Reason |
|---------|--------|
| Windows as a first-class target in this milestone | Linux and macOS slice deepening is still the highest-value next step |
| Release packaging migration | Packaging should wait until the owned runtime slice is deeper and more stable |
| Whole-repo or full-GUI parity claims | This milestone is about deepening the proven slice, not pretending the whole application is migrated |
| Broad repo-wide tooling enforcement | Keep the focus on product-slice ownership first; wider tooling ratchets can follow |

## Traceability

Which phases will cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| EXEC-01 | Phase 7 | Pending |
| EXEC-02 | Phase 9 | Pending |
| EXEC-03 | Phase 7 | Pending |
| BRDG-01 | Phase 7 | Pending |
| BRDG-02 | Phase 8 | Pending |
| BRDG-03 | Phase 10 | Pending |
| DEEP-01 | Phase 8 | Pending |
| DEEP-02 | Phase 9 | Pending |

**Coverage:**
- v1.1 requirements: 8 total
- Mapped to phases: 8
- Unmapped: 0 ✓

---
*Requirements defined: 2026-04-09*
*Last updated: 2026-04-09 after initial v1.1 roadmap creation*
