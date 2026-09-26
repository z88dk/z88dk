#!/bin/sh
# Red-green runtime test for the fixlabels.pl string-literal dot corruption.
#
# bridge_postproc.sh -> fixlabels.pl flattens clang's dotted LABELS
# (.LBB0_4, L_.str.1, _counter.3) to z80asm-legal names.  Its generic
# "identifier-with-internal-dot -> dots become _" rule used to run over the
# whole line, so the body of a `DEFM "..."` string literal (from `.asciz`) was
# rewritten too: "file.txt" was emitted as "file_txt", "1.2.3" as "1_2_3",
# "a.b.c" as "a_b_c".  The corruption happens AFTER clang, so clang's constant
# folding still sees the correct text -- only the STORED bytes are wrong, which
# is why printing the literal with %s (a runtime read) is the reliable oracle.
#
# GREEN: dotted literals round-trip; output line prints them with dots intact.
# RED  : pre-fix fixlabels.pl prints "file_txt 1_2_3 3_14159 a_b_c" -> the
#        exact-match check below fails.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_strlit.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_strlit.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O1 -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

# fn="file.txt" ver="1.2.3" pi="3.14159" buf="a.b.c" ok=1
EXP='strlit file.txt 1.2.3 3.14159 a.b.c 1'
echo "$OUT" | grep -qF "$EXP" || fail "dotted string literal corrupted. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 preserves '.' in string literals (fixlabels.pl masks quoted strings)"
