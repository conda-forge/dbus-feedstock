#!/bin/bash
set -euo pipefail

meson setup build \
  --wrap-mode=nodownload \
  --libdir=lib \
  -Dprefix="${PREFIX}" \
  -Dsystemd=disabled \
  -Dselinux=disabled \
  -Dxml_docs=disabled \
  -Dlaunchd_agent_dir="${PREFIX}"

meson compile -C build
if [[ $(uname) != Darwin ]]; then
  meson test -C build
fi
meson install -C build
