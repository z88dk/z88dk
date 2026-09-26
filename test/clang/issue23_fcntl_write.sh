#!/bin/sh
# Regression guard for ravn/z88dk#23 (raw fcntl open/write under clang).
# FIXED by z80_smallc: clang's __smallc now maps to __attribute__((z80_smallc))
# (left-to-right stack), so the natural-order __ZPROTO3 open/read/write
# declarations call the +cpm classic-clib stack workers correctly and write()
# returns the byte count (3).  See ravn/llvm-z80#279, ravn/z88dk#41.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/issue23_fcntl_write.c"
EXPECT_FIXED=1        # ravn/z88dk#23 FIXED by z80_smallc (ravn/llvm-z80#279)

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

zcc +cpm -compiler=llvmz80 --opt-code-size -create-app -o "$WORK/t" "$SRC" \
    >"$WORK/build.log" 2>&1 || { cat "$WORK/build.log"; echo "FAIL: build"; exit 1; }

OUT=$(perl -e 'alarm shift; exec @ARGV' 10 "$NTVCM" "$WORK/t.com" 2>/dev/null \
        | tr -d '\r' | head -10)
W=$(echo "$OUT" | sed -n 's/^write=//p' | head -1)

if [ "$W" = "3" ]; then
    echo "GREEN: write() returned 3 -> ravn/z88dk#23 appears FIXED"
    [ "$EXPECT_FIXED" = 1 ] && { echo "PASS: issue23_fcntl_write"; exit 0; }
    echo "ACTION: set EXPECT_FIXED=1 in this fixture and assert GREEN."
    exit 0
fi

echo "KNOWN-FAIL (ravn/z88dk#23): write()=$W (want 3); output:"
echo "$OUT" | sed 's/^/    /'
if [ "$EXPECT_FIXED" = 1 ]; then
    echo "FAIL: expected #23 fixed but write() still returns $W"; exit 1
fi
echo "SKIP-KNOWN-FAIL: ravn/z88dk#23 still open (exit 0 to keep suite green)"
exit 0
