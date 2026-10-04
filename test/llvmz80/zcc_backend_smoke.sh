#!/bin/sh
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

case "$COMPILE_LINE" in
    *-fdefault-calling-conv=sdcccall0*) ;;
    *)
        echo "FAIL: llvmz80 does not default to sdcccall(0)"
        exit 1
        ;;
esac

if ! "$ZCC" +cpm -compiler=llvmz80 -v -c "$WORK/main.c" \
        -Cg-fdefault-calling-conv=sdcccall1 -o "$WORK/override.o" \
        >"$WORK/override.log" 2>&1; then
    cat "$WORK/override.log"
    echo "FAIL: explicit sdcccall(1) override failed"
    exit 1
fi

[ -f "$WORK/override.o" ] || {
    echo "FAIL: override did not produce an object file"
    exit 1
}

OVERRIDE_LINE=$(grep -F -- '-S ' "$WORK/override.log" | grep -F "$LLVMZ80EXE" | head -1 || true)
case "$OVERRIDE_LINE" in
    *-fdefault-calling-conv=sdcccall0*-fdefault-calling-conv=sdcccall1*) ;;
    *)
        cat "$WORK/override.log"
        echo "FAIL: user calling convention must follow the default"
        exit 1
        ;;
esac

for convention in default sdcccall1; do
    set --
    if [ "$convention" = sdcccall1 ]; then
        set -- -Cg-fdefault-calling-conv=sdcccall1
    fi
    if ! "$ZCC" +cpm -compiler=llvmz80 -a -Cg-emit-llvm "$@" \
            "$WORK/main.c" -o "$WORK/$convention.asm" \
            >"$WORK/$convention.log" 2>&1; then
        cat "$WORK/$convention.log"
        echo "FAIL: cannot inspect $convention function ABI"
        exit 1
    fi
    DEFINITION=$(grep 'define .*@sum(' "$WORK/$convention.asm" || true)
    case "$convention:$DEFINITION" in
        default:*z80_sdcccall0*) ;;
        sdcccall1:*z80_sdcccall0*|*:)
            echo "FAIL: unexpected $convention function ABI: $DEFINITION"
            exit 1
            ;;
        sdcccall1:*) ;;
        *)
            echo "FAIL: default function does not use sdcccall(0): $DEFINITION"
            exit 1
            ;;
    esac
done

echo "PASS: zcc compiles llvmz80 C with the native z88dk target triple"
