#!/bin/sh
# Red-green runtime test for the llvmz80 fd-layer ABI fixed in Group C
# klasse 3: open/read/write (include/fcntl.h __ZPROTO3 class).
#
# Unlike the +cpm/ntvcm oracles in this directory, the fd-layer lives in the
# `+test` target and is driven by z88dk-ticks host-file SYSCALLs, so this
# oracle builds with `zcc +test ... -b msx` and runs under z88dk-ticks with a
# fixture file (FIX.TXT) in the emulator's CWD.
#
# GREEN: open() returns a valid fd, read() returns the exact 10-byte count
#        with the correct byte checksum, write() returns 3.
# RED  : open() returns a garbage fd (245) and read() a garbage count -- the
#        __ZPROTO3 register contract was not honoured by the stack worker.
#
# Usage: LLVMZ80EXE=/path/to/clang ZCCCFG=<z88dk>/lib/config \
#        PATH=<z88dk>/bin:$PATH ./runtime_fcntl.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_fcntl.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
command -v z88dk-ticks >/dev/null 2>&1 || { echo "SKIP: z88dk-ticks not on PATH"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# fixture: exactly 10 bytes "abcdefghij", checksum 'a'..'j' = 1015
printf 'abcdefghij' > "$WORK/FIX.TXT"

if ! zcc +test -vn -compiler=llvmz80 -o "$WORK/rt.bin" "$SRC" >"$WORK/build.log" 2>&1; then
    # The +test target's clib (test_clib.lib) is an on-demand-built artifact that
    # a +cpm-only z88dk tree need not have.  A missing test_clib.lib is an
    # ENVIRONMENT gap, not a code failure -- SKIP (like the zcc/ticks guards
    # above) so a +cpm-only checkout runs the suite clean.  This test needs
    # +test on purpose: it asserts BYTE-EXACT fd-layer semantics (read of a
    # 10-byte file returns exactly 10, byte-exact write) that only the +test
    # host-file SYSCALL workers provide; CP/M's record-oriented BDOS cannot, so
    # the +cpm fd-layer is covered instead by issue23_fcntl_write (open/write)
    # and the byte-accurate FILE* layer by runtime_file*/runtime_fileio_*.
    if grep -q 'test_clib\.lib' "$WORK/build.log"; then
        echo "SKIP: +test target not built (test_clib.lib absent); +cpm fd-layer covered by issue23_fcntl_write"
        exit 0
    fi
    echo "--- build log ---"; cat "$WORK/build.log"
    echo "FAIL: build failed"; exit 1
fi

# ticks reads host files relative to its CWD -> run from the fixture dir.
OUT=$(cd "$WORK" && z88dk-ticks -w 30 -b msx rt.bin 2>/dev/null | grep '^fcntl ' | tr -d '\r')

case "$OUT" in
    "fcntl fd_ok=1 n=10 sum=1015 wn=3")
        echo "PASS: llvmz80 fd-layer open/read/write ABI correct (got: $OUT)"
        ;;
    *)
        echo "FAIL: unexpected output"
        echo "  got:    $OUT"
        echo "  expect: fcntl fd_ok=1 n=10 sum=1015 wn=3"
        exit 1
        ;;
esac
