#!/usr/bin/env bash
set -euo pipefail

./prusa build --platform macos
./prusa test --platform macos
./prusa fmt --check
./prusa lint
./prusa compdb

test -f build/compdb/compile_commands.json
