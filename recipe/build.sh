#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./build-aux

rm -f ${PREFIX}/lib/*.la

if [[ ${target_platform} == linux-ppc64le ]] ; then
  # Disable some tests that fail on QEMU builds:
  #   ERROR: test-fdpass - Bail out! file descriptor 31 leaked in next test-case.
  #   ERROR: test-sysdeps - Bail out! ERROR:internals/sysdeps.c:139:test_command_for_pid: assertion failed (_dbus_string_get_const_data (&string) == expected): ("/usr/bin/qemu-ppc64le-static $SRC_DIR/test/test-sleep-forever bees" == "$SRC_DIR/test/test-sleep-forever bees")
  sed -i.bak '
    /^test_\(fdpass\|sysdeps\)_/{
      : a
      /\\$/{
        N
        b a
      }
      d
    }
    /test-\(fdpass\|sysdeps\)/{
      d
    }' test/Makefile.am
  autoreconf -fi
fi
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
