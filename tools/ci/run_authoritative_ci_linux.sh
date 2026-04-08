#!/usr/bin/env bash
set -euo pipefail

./prusa build --platform linux
./prusa test --platform linux
