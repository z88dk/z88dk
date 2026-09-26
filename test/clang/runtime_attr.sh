#!/bin/sh
# Runtime test: see runtime_attr.c.  Portable across classic clib and newlib.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_attr.c"
command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
fail() { echo "FAIL: $1"; exit 1; }
if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
    echo "--- build log ---"; cat "$WORK/build.log"; fail "zcc build failed"
fi
OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | head -1 | tr -d '\r')
EXPECT="attr=42"
if [ "$OUT" = "$EXPECT" ]; then
    echo "PASS: runtime_attr"
else
    echo "FAIL: unexpected output"; echo "  got:    $OUT"; echo "  expect: $EXPECT"; exit 1
fi
