#!/bin/sh
# printf converter auto-selection for -compiler=llvmz80 (ravn/z88dk#42).
#
# GREEN: STOCK classic printf with NO `#pragma printf` and NO IEEE route --
#        just `--math32` -- renders %6.1f/%f/%d/%s correctly, because zcc's
#        zpragma -autoformat pass scans the call sites and auto-selects the
#        classic converters exactly like sccz80 does internally.
# RED  : before -autoformat, the default converter table omits float, so
#        printf("%6.1f") printed a literal "6.1f" and desynced the varargs.
#
# Uses --math32 (clang double == binary32). Skips if zcc/ntvcm unavailable.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_printf_autoformat.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

# NOTE: deliberately NO -Dpragma and NO manual converter selection -- this
# proves the -autoformat pass picks the classic %f/%e/%g converters by itself.
if ! zcc +cpm -compiler=llvmz80 --math32 -O2 \
        -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
    echo "--- build log ---"; cat "$WORK/build.log"
    fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')
echo "$OUT" | grep -qF "PASS autoformat" \
    || fail "auto-selection wrong (float not linked?). got: [$OUT]"

echo "PASS: stock printf(\"%f\") auto-selects classic converters (no #pragma)"
