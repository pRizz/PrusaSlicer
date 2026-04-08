#!/usr/bin/env bash
set -euo pipefail

if command -v sudo >/dev/null 2>&1 && [[ "$(id -u)" -ne 0 ]]; then
  SUDO=(sudo)
else
  SUDO=()
fi

"${SUDO[@]}" apt-get update
"${SUDO[@]}" apt-get install -y \
  build-essential \
  catch2 \
  clang-tidy \
  cmake \
  curl \
  git \
  libboost-all-dev \
  libexpat1-dev \
  libpng-dev \
  libtbb-dev \
  ninja-build \
  openjdk-21-jdk \
  pkg-config \
  python3 \
  unzip \
  zip

if ! command -v bazelisk >/dev/null 2>&1; then
  arch="$(uname -m)"
  case "${arch}" in
    x86_64)
      bazelisk_arch="amd64"
      ;;
    aarch64|arm64)
      bazelisk_arch="arm64"
      ;;
    *)
      printf 'Unsupported Linux architecture for bazelisk bootstrap: %s\n' "${arch}" >&2
      exit 1
      ;;
  esac

  curl -fsSL -o /tmp/bazelisk "https://github.com/bazelbuild/bazelisk/releases/download/v1.22.0/bazelisk-linux-${bazelisk_arch}"
  if [[ -w /usr/local/bin ]]; then
    install -m 0755 /tmp/bazelisk /usr/local/bin/bazelisk
  elif ((${#SUDO[@]})); then
    "${SUDO[@]}" install -m 0755 /tmp/bazelisk /usr/local/bin/bazelisk
  else
    mkdir -p "${HOME}/.local/bin"
    install -m 0755 /tmp/bazelisk "${HOME}/.local/bin/bazelisk"
    export PATH="${HOME}/.local/bin:${PATH}"
    if [[ -n "${GITHUB_PATH:-}" ]]; then
      printf '%s\n' "${HOME}/.local/bin" >> "${GITHUB_PATH}"
    fi
  fi
fi
