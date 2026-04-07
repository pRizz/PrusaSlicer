#!/usr/bin/env bash
set -euo pipefail

find_clang_format() {
  if [[ -x /opt/homebrew/opt/llvm/bin/clang-format ]]; then
    printf '%s\n' /opt/homebrew/opt/llvm/bin/clang-format
    return
  fi

  if command -v clang-format >/dev/null 2>&1; then
    command -v clang-format
    return
  fi

  if xcrun --find clang-format >/dev/null 2>&1; then
    xcrun --find clang-format
    return
  fi

  printf 'Unable to find clang-format.\n' >&2
  exit 1
}

workspace_root="${BUILD_WORKSPACE_DIRECTORY:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." && pwd)}"
mode="check"

if (($# == 0)); then
  printf 'No formatting inputs were provided.\n' >&2
  exit 1
fi

case "${1}" in
  --mode=check)
    mode="check"
    shift
    ;;
  --mode=fix)
    mode="fix"
    shift
    ;;
  *)
    printf 'Unknown mode: %s\n' "${1}" >&2
    exit 1
    ;;
esac

clang_format="$(find_clang_format)"

for relative_path in "$@"; do
  absolute_path="${workspace_root}/${relative_path}"
  if [[ ! -f "${absolute_path}" ]]; then
    printf 'Missing formatting input: %s\n' "${absolute_path}" >&2
    exit 1
  fi

  if [[ "${mode}" == "check" ]]; then
    "${clang_format}" --dry-run --Werror "${absolute_path}"
  else
    "${clang_format}" -i "${absolute_path}"
  fi
done
