#!/usr/bin/env bash
set -euo pipefail

bazelisk build --config=dev --config=macos //src:PrusaSlicer
./prusa test --platform macos
./prusa fmt --check
./prusa lint
./prusa compdb

test -f build/compdb/compile_commands.json
