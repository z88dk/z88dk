#!/bin/sh
set -eu

DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$DIR/test_env.sh"
: "${NTVCM:?Set NTVCM to the emulator}"

WORK=$(mktemp -d "$TMPDIR/minimal-abi.XXXXXX")
trap 'rm -rf "$WORK"' EXIT HUP INT TERM
cd "$WORK"

for optimisation in O0 O2 Os; do
for test in varargs header_abi math32; do
    mathlib=
    if [ "$test" = math32 ]; then
        mathlib=-lm
    fi
    "$ZCC" +cpm -compiler=llvmz80 "-Cg-$optimisation" \
        -pragma-define:CLIB_MALLOC_HEAP_SIZE=1024 -create-app \
        "$DIR/$test.c" $mathlib -o "$test" > "$test-build.log" 2>&1 || {
        cat "$test-build.log"
        exit 1
    }
    program=$(printf '%s.COM' "$test" | tr '[:lower:]' '[:upper:]')
    perl -e 'alarm shift; exec @ARGV' 15 "$NTVCM" "$program" > "$test-output.log" 2>&1 || {
        cat "$test-output.log"
        exit 1
    }
    tr -d '\r' < "$test-output.log" > "$test-clean.log"
    printf 'ALL PASS\n' > "$test-expected.log"
    if [ "$test" = header_abi ]; then
        printf X >> "$test-expected.log"
    fi
    cmp "$test-expected.log" "$test-clean.log"
    printf 'PASS: %s gnu23 %s\n' "$test" "$optimisation"
done
done
