#!/bin/sh
# Red-green runtime test: console output must survive an intervening fopen.
# See runtime_file_console.c for the full defect description.
#
# GREEN (all clibs): the program prints BOTH lines to the console
#        BEFORE
#        AFTER
#
# History: opening a file used to rebind the stdout console stream to the
#        CP/M file driver on the newlib routes (newlib_iy/_ix, and identically
#        SDCC sdcc_iy), misrouting the second puts() into the file so the
#        console showed only "BEFORE" (z88dk #3025 file-driver defect; write
#        path fine, console stream corrupted).  That gap is now CLOSED on every
#        route (verified newlib_iy/newlib_ix/sdcc_iy all print AFTER), so the
#        former newlib XFAIL is retired and every clib is a hard PASS/FAIL.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_file_console.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_file_console.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 \
        -pragma-define:CLIB_MALLOC_HEAP_SIZE=4000 \
        -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

# Run from WORK so the created file (and any misrouted output) stays contained.
# A wrong stdio/file interaction can hang; cap the run so a hang reports as FAIL.
OUT=$(cd "$WORK" && "$NTVCM" RT.COM 2>/dev/null | tr -d '\r')

echo "$OUT" | grep -qx "BEFORE" || fail "missing BEFORE (console broken before fopen). got: [$OUT]"

# The console-after-fopen defect (formerly newlib-only) is fixed on every
# route, so this is now a hard assertion for all clibs: AFTER must appear.
echo "$OUT" | grep -qx "AFTER" || fail "console output after fopen was lost/misrouted. got: [$OUT]"
echo "PASS: console output survives an intervening fopen (BEFORE + AFTER both printed)"
