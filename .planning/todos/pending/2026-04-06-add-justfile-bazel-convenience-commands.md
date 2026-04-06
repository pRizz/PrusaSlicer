---
created: 2026-04-06T06:20 CDT
title: Add justfile Bazel convenience commands
area: tooling
files:
  - justfile
  - .bazelrc
  - prusa
  - tools/bazel/README.md
---

## Problem

Phase 2 established a Bazel-first repo root with `./prusa`, `.bazelrc`, and documented proof commands, but common contributor workflows still require remembering several raw Bazel or wrapper invocations. A repo-root convenience surface would make everyday build, test, and proof-slice commands easier to discover without changing the authoritative Bazel path.

## Solution

Add a repo-root `justfile` with thin recipes that delegate to the existing Bazel and `./prusa` commands instead of introducing new build logic. Start with common developer tasks such as `build`, `test`, `help`, `fmt`, `lint`, `compdb`, and the Phase 3 macOS/Linux proof-slice commands, including a Linux-via-Docker helper if it stays clearly documented and optional.
