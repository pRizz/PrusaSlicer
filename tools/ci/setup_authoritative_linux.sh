#!/usr/bin/env bash
set -euo pipefail

if command -v sudo >/dev/null 2>&1 && [[ "$(id -u)" -ne 0 ]]; then
  SUDO=(sudo)
else
  SUDO=()
fi

"${SUDO[@]}" apt-get update
"${SUDO[@]}" apt-get install -y \
  autoconf \
  automake \
  build-essential \
  catch2 \
  clang-format \
  clang-tidy \
  cmake \
  curl \
  git \
  libboost-all-dev \
  libexpat1-dev \
  libtool \
  libpng-dev \
  libtbb-dev \
  m4 \
  ninja-build \
  openjdk-21-jdk \
  pkg-config \
  python3 \
  texinfo \
  unzip \
  zip \
  zlib1g-dev

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

mkdir -p deps/.pkg_cache

if [[ ! -f deps/build/destdir/usr/local/include/cereal/cereal.hpp || ! -f deps/build/destdir/usr/local/include/LibBGCode/core/core.hpp ]]; then
  cmake -S deps -B deps/build -DDEP_DOWNLOAD_DIR="$PWD/deps/.pkg_cache"
  cmake --build deps/build --parallel 3 --target dep_Boost dep_Eigen dep_Catch2 dep_Cereal dep_LibBGCode
fi
