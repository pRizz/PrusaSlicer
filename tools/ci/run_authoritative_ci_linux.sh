#!/usr/bin/env bash
set -euo pipefail

./prusa build --platform linux
./prusa test --platform linux
./prusa fmt --check
./prusa lint
./prusa compdb

test -f build/compdb/compile_commands.json
