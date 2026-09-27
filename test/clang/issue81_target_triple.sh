#!/bin/sh
# Red-green test for ravn/z88dk #81: zcc's Clang driver invocation for
# -compiler=llvmz80 should use --target=z80-unknown-none-z88dk (ravn/llvm-z80
# #389) instead of manually stitching --target=z80 plus the three opt-in
# -mllvm flags (-z80-float-sdcccall0, -z80-classic-libc-cc,
# -z80-asm-format=z80asm) and -mdouble=32, all of which the triple now
# defaults to.
#
# GREEN: `zcc +cpm -compiler=llvmz80 -v` shows a Clang compile-stage
#        invocation containing --target=z80-unknown-none-z88dk, and the three
#        manual -mllvm flags plus -mdouble=32 are gone (subsumed by the
#        triple). A double-arithmetic program still runs correctly under
#        ntvcm, proving the switch is behaviour-preserving.
# RED  : today the invocation still reads `--target=z80 -S -mdouble=32
#        -std=gnu23 -o - -O2 -mllvm -z80-float-sdcccall0 -mllvm
#        -z80-classic-libc-cc -mllvm -z80-asm-format=z80asm` -- no
#        `z80-unknown-none-z88dk` substring anywhere in the invocation.
#
# Usage: LLVMZ80EXE=<llvm-z80 build>/bin/clang ZCCCFG=<z88dk>/lib/config \
#        PATH=<z88dk>/bin:$PATH NTVCM=/path/to/ntvcm ./issue81_target_triple.sh
# Skips (exit 0) if the compiler or the emulator is unavailable.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
[ -f "$DIR/test_env.sh" ] && . "$DIR/test_env.sh"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

cat > "$WORK/t.c" <<'EOF'
#include <stdio.h>
double a = 3.5, b = 2.0;
int main(void) {
    if (a + b == 5.5 && a * b == 7.0) {
        printf("ALL PASS\n");
    } else {
        printf("FAIL sum=%d prod=%d\n", (int)(a + b), (int)(a * b));
    }
    return 0;
}
EOF

# ---- 1. Inspect the driver's own Clang invocation (-v) ----
if ! zcc +cpm -compiler=llvmz80 -v -c "$WORK/t.c" -o "$WORK/t.o" \
        >"$WORK/build.log" 2>&1; then
    echo "--- build log ---"; cat "$WORK/build.log"
    fail "zcc -c build failed"
fi

# The compile-stage line is the one invoking $LLVMZ80EXE with -S (assembly
# output); the preprocess-stage line (-E) is a separate invocation.
COMPILE_LINE=$(grep -F -- '-S ' "$WORK/build.log" | grep -F "$LLVMZ80EXE" | head -1)
[ -n "$COMPILE_LINE" ] || fail "could not find Clang compile-stage invocation in build log"

case "$COMPILE_LINE" in
    *z80-unknown-none-z88dk*) : ;;
    *) fail "compile invocation missing --target=z80-unknown-none-z88dk: $COMPILE_LINE" ;;
esac

case "$COMPILE_LINE" in
    *-z80-float-sdcccall0*|*-z80-classic-libc-cc*|*-z80-asm-format=z80asm*|*-mdouble=32*)
        fail "compile invocation still passes manual flags the triple now defaults to: $COMPILE_LINE" ;;
esac

# ---- 2. Behaviour is unchanged: double arithmetic still runs correctly ----
if ! zcc +cpm -compiler=llvmz80 -create-app -lm -o "$WORK/rt" "$WORK/t.c" \
        >"$WORK/build2.log" 2>&1; then
    echo "--- build log ---"; cat "$WORK/build2.log"
    fail "zcc full build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')
echo "$OUT" | grep -qF "ALL PASS" || fail "double arithmetic under the new triple wrong. got: [$OUT]"

echo "PASS: zcc -compiler=llvmz80 invokes Clang with --target=z80-unknown-none-z88dk"
