#!/usr/bin/env bash
set -euo pipefail

find_bazel_prefix() {
  if command -v bazelisk >/dev/null 2>&1; then
    BAZEL_PREFIX=(bazelisk)
    return
  fi

  if command -v bazel >/dev/null 2>&1; then
    BAZEL_PREFIX=(bazel)
    return
  fi

  if command -v npx >/dev/null 2>&1; then
    BAZEL_PREFIX=(npx -y @bazel/bazelisk)
    return
  fi

  printf 'Unable to find bazelisk, bazel, or npx for Bazel queries.\n' >&2
  exit 1
}

host_platform() {
  case "$(uname -s)" in
    Linux)
      printf '%s\n' linux
      ;;
    Darwin)
      printf '%s\n' macos
      ;;
    *)
      printf '%s\n' linux
      ;;
  esac
}

find_clang_tidy() {
  if [[ -x /opt/homebrew/opt/llvm/bin/clang-tidy ]]; then
    printf '%s\n' /opt/homebrew/opt/llvm/bin/clang-tidy
    return
  fi

  if command -v clang-tidy >/dev/null 2>&1; then
    command -v clang-tidy
    return
  fi

  printf 'Unable to find clang-tidy. Install LLVM from Homebrew or add clang-tidy to PATH.\n' >&2
  exit 1
}

workspace_root="${BUILD_WORKSPACE_DIRECTORY:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." && pwd)}"
raw_output="$(mktemp)"
trap 'rm -f "${raw_output}"' EXIT

cd "${workspace_root}"

if (($# == 0)); then
  printf 'No lint inputs were provided.\n' >&2
  exit 1
fi

declare -a BAZEL_PREFIX
find_bazel_prefix
clang_tidy="$(find_clang_tidy)"
platform="$(host_platform)"
execution_root="$("${BAZEL_PREFIX[@]}" info --config=dev --config="${platform}" execution_root | tail -n 1)"

"${BAZEL_PREFIX[@]}" aquery \
  --config=dev \
  --config="${platform}" \
  --output=jsonproto \
  --include_commandline \
  'mnemonic("CppCompile", deps(//src:PrusaSlicer + //tests/libslic3r:config_test + //tests/thumbnails:thumbnails_test))' > "${raw_output}"

python3 - "$workspace_root" "$execution_root" "$clang_tidy" "${raw_output}" "$@" <<'PY'
import json
import pathlib
import subprocess
import sys

workspace_root = pathlib.Path(sys.argv[1])
execution_root = pathlib.Path(sys.argv[2])
clang_tidy = sys.argv[3]
raw_path = pathlib.Path(sys.argv[4])
targets = set(sys.argv[5:])

raw_text = raw_path.read_text()
json_start = raw_text.find("{")
if json_start == -1:
    raise SystemExit("Could not find JSON payload in Bazel aquery output.")

payload = json.loads(raw_text[json_start:])

selected_actions = []
for action in payload.get("actions", []):
    arguments = action.get("arguments", [])
    if not arguments:
        continue

    try:
        source_index = arguments.index("-c") + 1
    except ValueError:
        continue

    source_path = arguments[source_index]
    if source_path not in targets:
        continue

    filtered_args = []
    skip_next = 0
    for argument in arguments[1:]:
        if skip_next:
            skip_next -= 1
            continue
        if argument in {"-c", "-o", "-MF"}:
            skip_next = 1
            continue
        if argument in {"-MD", "-MMD", "-fcolor-diagnostics", "-no-canonical-prefixes"}:
            continue
        if argument.startswith("-frandom-seed="):
            continue
        filtered_args.append(argument)

    selected_actions.append((source_path, filtered_args))

missing = sorted(targets.difference(source for source, _ in selected_actions))
if missing:
    raise SystemExit(f"Missing compile actions for lint targets: {', '.join(missing)}")

for source_path, filtered_args in selected_actions:
    absolute_source = workspace_root / source_path
    command = [clang_tidy, str(absolute_source), "--warnings-as-errors=*", "--"] + filtered_args
    subprocess.run(command, cwd=execution_root, check=True)
PY
