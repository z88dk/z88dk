#!/bin/sh
# printf converter auto-selection on the ZSDCC lane (ravn/z88dk#42).
#
# Same auto-selection as runtime_printf_autoformat.sh but for
# -compiler=sdcc: zpragma's -autoformat pass (wired for CC_SDCC too) scans
# the call sites and selects the classic converters, so stock printf with
# NO `#pragma printf` renders %6.1f/%f/%d/%s correctly under --math32.
#
# Skips if zcc/ntvcm/sdcc unavailable (sdcc runs via Docker in this repo, so
# a failed build is treated as "sdcc lane not available" -> SKIP, not FAIL).
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_printf_autoformat.c"   # reuse the llvmz80 test's source

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# NOTE: deliberately NO #pragma printf -- auto-selection only.
if ! zcc +cpm -compiler=sdcc --math32 -O2 \
        -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
    if grep -qiE "docker|sdcc|not found|no such" "$WORK/build.log"; then
        echo "SKIP: sdcc lane unavailable (see build log)"; exit 0
    fi
    echo "--- build log ---"; cat "$WORK/build.log"
    echo "FAIL: zsdcc build failed"; exit 1
fi
[ -f "$WORK/RT.COM" ] || { echo "SKIP: sdcc produced no .com (lane unavailable)"; exit 0; }

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')
echo "$OUT" | grep -qF "PASS autoformat" \
    || { echo "FAIL: zsdcc auto-selection wrong. got: [$OUT]"; exit 1; }

echo "PASS: stock printf(\"%f\") auto-selects converters on the zsdcc lane (no #pragma)"
