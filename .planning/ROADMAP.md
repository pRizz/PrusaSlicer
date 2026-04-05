# Roadmap: PrusaSlicer Build Stack Modernization

## Overview

This roadmap takes PrusaSlicer from a CMake-first build and dependency workflow to an authoritative modern build stack for Linux and macOS. The path starts by making the build-system decision explicit, then establishes the new build graph and dependency policy, migrates real product targets, adds contributor tooling and validation, and finally makes CI and documented workflows enforce the new authority.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Evaluate Build-System Fit** - Choose the authoritative build stack with explicit migration criteria and cutoff policy
- [x] **Phase 2: Establish Build Graph Skeleton** - Create the root build definitions, command surface, and platform/dependency policy
- [ ] **Phase 3: Migrate Core Targets and Dependencies** - Build the real product on Linux and macOS through the new path with explicit third-party ownership
- [ ] **Phase 4: Add Local Tooling and Validation** - Make tests, formatting, linting, and editor workflows work without the legacy build
- [ ] **Phase 5: Make the New Path Authoritative** - Move CI and contributor guidance onto the new path and define the legacy exit

## Phase Details

### Phase 1: Evaluate Build-System Fit
**Goal**: Decide between Bazel and Meson + Ninja using explicit migration criteria, parity gates, and authority-cutoff rules.
**Depends on**: Nothing (first phase)
**Requirements**: [EVAL-01, EVAL-02, EVAL-03]
**Success Criteria** (what must be TRUE):
  1. Maintainers can compare Bazel and Meson + Ninja against written evaluation criteria for PrusaSlicer.
  2. Maintainers can point to one selected authoritative build stack with rationale and rejection criteria for the alternative.
  3. Maintainers can describe the parity gates and cutoff policy that will end long-term dual-build authority.
**Plans**: 4 plans

Plans:
- [x] 01-01: Define evaluation criteria, parity gates, and authority cutoff signals
- [x] 01-02: Run the Bazel vs Meson comparison and record the build-system decision
- [x] 01-03: Close the Linux proof gap and refresh the scorecard from real Linux evidence
- [x] 01-04: Validate Bazel tooling evidence and refresh the decision packet

### Phase 2: Establish Build Graph Skeleton
**Goal**: Put the selected build system at repo root with one authoritative command surface and explicit policy for platform and system-library exceptions.
**Depends on**: Phase 1
**Requirements**: [BLD-03, DEPS-02]
**Success Criteria** (what must be TRUE):
  1. Contributors can see one documented authoritative build entry point at the repository root.
  2. Maintainers can define when system-library exceptions are allowed and where they are documented.
  3. The selected build system has a visible root graph/toolchain structure for Linux and macOS.
**Plans**: 2 plans

Plans:
- [x] 02-01: Create root build files, target conventions, and command surface
- [x] 02-02: Define platform branching and system-library exception policy

### Phase 3: Migrate Core Targets and Dependencies
**Goal**: Build the real PrusaSlicer application on Linux and macOS through the new path with explicit third-party dependency ownership and tracked bridge boundaries.
**Depends on**: Phase 2
**Requirements**: [BLD-01, BLD-02, DEPS-01, DEPS-03]
**Success Criteria** (what must be TRUE):
  1. Contributors can build the PrusaSlicer application on Linux through the authoritative path.
  2. Contributors can build the PrusaSlicer application on macOS through the authoritative path.
  3. Maintainers can declare third-party dependencies through explicit, version-pinned metadata in the new build stack.
  4. Maintainers can identify every temporary bridge to legacy tooling with ownership and retirement criteria.
**Plans**: TBD

Plans:
- [ ] 03-01: Bring up Linux/macOS app targets under the selected build system
- [ ] 03-02: Move core dependencies into explicit ownership and document bridge inventory

### Phase 4: Add Local Tooling and Validation
**Goal**: Make the new path credible for daily contributor use by running tests and developer tooling without falling back to the legacy build.
**Depends on**: Phase 3
**Requirements**: [BLD-04, TOOL-01, TOOL-02, TOOL-03]
**Success Criteria** (what must be TRUE):
  1. Contributors can run the core automated test suites through the authoritative path on Linux and macOS.
  2. Contributors can run repository formatting through the authoritative toolchain.
  3. Contributors can run an initial lint/static-analysis pass through the authoritative toolchain.
  4. Contributors can use `clangd` or equivalent editor metadata without generating it from the legacy build.
**Plans**: TBD

Plans:
- [ ] 04-01: Wire core test execution into the authoritative graph
- [ ] 04-02: Add formatting, linting, and editor metadata targets

### Phase 5: Make the New Path Authoritative
**Goal**: Put Linux/macOS CI and contributor guidance on the new path so the repo has one enforceable source of truth and a clear legacy exit.
**Depends on**: Phase 4
**Requirements**: [TOOL-04, CI-01, CI-02, CI-03]
**Success Criteria** (what must be TRUE):
  1. Maintainers can run Linux CI jobs against the same authoritative targets used locally.
  2. Maintainers can run macOS CI jobs against the same authoritative targets used locally.
  3. Contributors can follow one maintained guide for Linux and macOS build, test, format, lint, and editor setup.
  4. Maintainers can verify that the authoritative path, not the legacy build, is the gate for new build/test/tooling changes.
**Plans**: TBD

Plans:
- [ ] 05-01: Move Linux/macOS CI onto the authoritative targets
- [ ] 05-02: Publish contributor workflow docs and define the legacy exit steps

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Evaluate Build-System Fit | 4/4 | Complete | 2026-04-04 |
| 2. Establish Build Graph Skeleton | 2/2 | Complete | 2026-04-04 |
| 3. Migrate Core Targets and Dependencies | 0/TBD | Not started | - |
| 4. Add Local Tooling and Validation | 0/TBD | Not started | - |
| 5. Make the New Path Authoritative | 0/TBD | Not started | - |
