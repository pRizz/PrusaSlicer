#!/usr/bin/env bash
set -euo pipefail

brew update
brew install automake cmake git gettext libtool texinfo m4 zlib llvm ninja || true
brew upgrade automake cmake git gettext libtool texinfo m4 zlib llvm ninja || true

if ! command -v bazelisk >/dev/null 2>&1; then
  arch="$(uname -m)"
  case "${arch}" in
    x86_64)
      bazelisk_arch="amd64"
      ;;
    arm64)
      bazelisk_arch="arm64"
      ;;
    *)
      printf 'Unsupported macOS architecture for bazelisk bootstrap: %s\n' "${arch}" >&2
      exit 1
      ;;
  esac

  curl -fsSL -o /tmp/bazelisk "https://github.com/bazelbuild/bazelisk/releases/download/v1.22.0/bazelisk-darwin-${bazelisk_arch}"
  if [[ -w /usr/local/bin ]]; then
    install -m 0755 /tmp/bazelisk /usr/local/bin/bazelisk
  else
    mkdir -p "${HOME}/.local/bin"
    install -m 0755 /tmp/bazelisk "${HOME}/.local/bin/bazelisk"
    export PATH="${HOME}/.local/bin:${PATH}"
    if [[ -n "${GITHUB_PATH:-}" ]]; then
      printf '%s\n' "${HOME}/.local/bin" >> "${GITHUB_PATH}"
    fi
  fi
fi

mkdir -p deps/build
if [[ ! -f deps/build/destdir/usr/local/lib/libbgcode_core.a ]]; then
  (
    cd deps/build
    cmake ..
    cmake --build . -j3
  )
fi
