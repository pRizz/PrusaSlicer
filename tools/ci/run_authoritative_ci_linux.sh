#!/usr/bin/env bash
set -euo pipefail

bazelisk build --config=dev --config=linux //src:PrusaSlicer
./prusa test --platform linux
./prusa fmt --check
./prusa lint
./prusa compdb

test -f build/compdb/compile_commands.json
