#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./build-aux

rm -f ${PREFIX}/lib/*.la

./configure \
  --prefix=${PREFIX}   \
  --disable-systemd    \
  --disable-selinux    \
  --disable-xml-docs   \
  --without-x          \
  --with-launchd-agent-dir=${PREFIX}

make -j${CPU_COUNT} ${VERBOSE_AT}
if [[ $(uname) != Darwin ]]; then
  make check
fi
make install
