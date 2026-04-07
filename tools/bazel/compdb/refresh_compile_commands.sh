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

workspace_root="${BUILD_WORKSPACE_DIRECTORY:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." && pwd)}"
output_dir="${workspace_root}/build/compdb"
output_path="${output_dir}/compile_commands.json"
raw_output="$(mktemp)"
trap 'rm -f "${raw_output}"' EXIT

declare -a BAZEL_PREFIX
find_bazel_prefix

platform="$(host_platform)"
mkdir -p "${output_dir}"
cd "${workspace_root}"

execution_root="$("${BAZEL_PREFIX[@]}" info --config=dev --config="${platform}" execution_root | tail -n 1)"

"${BAZEL_PREFIX[@]}" aquery \
  --config=dev \
  --config="${platform}" \
  --output=jsonproto \
  --include_commandline \
  'mnemonic("CppCompile", deps(//src:PrusaSlicer + //tests/libslic3r:config_test + //tests/thumbnails:thumbnails_test))' > "${raw_output}"

python3 - "$workspace_root" "$execution_root" "$raw_output" "$output_path" <<'PY'
import json
import pathlib
import shlex
import sys

workspace_root = pathlib.Path(sys.argv[1])
execution_root = pathlib.Path(sys.argv[2])
raw_path = pathlib.Path(sys.argv[3])
output_path = pathlib.Path(sys.argv[4])

raw_text = raw_path.read_text()
json_start = raw_text.find("{")
if json_start == -1:
    raise SystemExit("Could not find JSON payload in Bazel aquery output.")

payload = json.loads(raw_text[json_start:])

commands = {}
for action in payload.get("actions", []):
    if action.get("mnemonic") != "CppCompile":
        continue

    arguments = action.get("arguments", [])
    if not arguments:
        continue

    try:
        source_index = arguments.index("-c") + 1
    except ValueError:
        continue

    source_path = arguments[source_index]
    absolute_source = (workspace_root / source_path).resolve()
    if not absolute_source.exists():
        continue

    commands[str(absolute_source)] = {
        "directory": str(execution_root),
        "command": shlex.join(arguments),
        "file": str(absolute_source),
    }

output_path.write_text(
    json.dumps([commands[key] for key in sorted(commands)], indent=2) + "\n"
)
PY

printf 'Wrote %s\n' "${output_path}"
