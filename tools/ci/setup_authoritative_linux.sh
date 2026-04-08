#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y \
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
  sudo install -m 0755 /tmp/bazelisk /usr/local/bin/bazelisk
fi
