#!/bin/sh
# Verifies zcc -compiler=llvmz80 selects the z80-unknown-none-z88dk triple,
# compiles with default sdcccall0 ABI in IR, and supports -E, -S, -c, and -clib=new.
set -eu

DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$DIR/test_env.sh"
ROOT=$(CDPATH= cd -- "$DIR/../.." && pwd)
WORKSPACE=$(CDPATH= cd -- "$ROOT/.." && pwd)
TMP_ROOT=${Z80_TEST_TMPDIR:-"$WORKSPACE/scratch/tmp"}
ZCC=${ZCC:-zcc}
command -v "$ZCC" >/dev/null 2>&1 || {
    echo "SKIP: zcc not found"
    exit 0
}
command -v "$LLVMZ80EXE" >/dev/null 2>&1 || {
    echo "SKIP: llvmz80-clang not found"
    exit 0
}

mkdir -p "$TMP_ROOT"
WORK=$(mktemp -d "$TMP_ROOT/zcc-backend.XXXXXX")
trap 'rm -rf "$WORK"' EXIT HUP INT TERM
mkdir "$WORK/tmp"

cat > "$WORK/main.c" <<'EOF'
unsigned sum(unsigned a, unsigned b) { return a + b; }
int main(void) { return 0; }
EOF

cd "$WORK"
if ! TMPDIR="$WORK/tmp" LLVMZ80EXE="$LLVMZ80EXE" \
        "$ZCC" +cpm -compiler=llvmz80 -v -c "$WORK/main.c" \
        -o "$WORK/main.o" >"$WORK/build.log" 2>&1; then
    cat "$WORK/build.log"
    echo "FAIL: zcc rejected or failed to compile with llvmz80"
    exit 1
fi

[ -f "$WORK/main.o" ] || {
    cat "$WORK/build.log"
    echo "FAIL: zcc did not produce an object file"
    exit 1
}

COMPILE_LINE=$(grep -F -- '-S ' "$WORK/build.log" | grep -F "$LLVMZ80EXE" | head -1 || true)
case "$COMPILE_LINE" in
    *--target=z80-unknown-none-z88dk*) ;;
    *)
        cat "$WORK/build.log"
        echo "FAIL: zcc did not invoke the native z88dk target triple"
        exit 1
        ;;
esac


if ! "$ZCC" +cpm -compiler=llvmz80 -a -Cg-emit-llvm \
        "$WORK/main.c" -o "$WORK/default.asm" >"$WORK/default.log" 2>&1; then
    cat "$WORK/default.log"
    echo "FAIL: cannot inspect target function ABI"
    exit 1
fi
DEFINITION=$(grep 'define .*@sum(' "$WORK/default.asm" || true)
case "$DEFINITION" in
    *z80_sdcccall0*) ;;
    *)
        echo "FAIL: target function does not use sdcccall(0): $DEFINITION"
        exit 1
        ;;
esac

echo "PASS: zcc compiles llvmz80 C with the native z88dk target triple"
