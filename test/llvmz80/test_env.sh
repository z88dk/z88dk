#!/bin/sh

LLVMZ80_TEST_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
Z88DK_ROOT=$(CDPATH= cd -- "$LLVMZ80_TEST_DIR/../.." && pwd)
ZCC=${ZCC:-"$Z88DK_ROOT/bin/zcc"}
ZCCCFG=${ZCCCFG:-"$Z88DK_ROOT/lib/config"}
: "${LLVMZ80EXE:?Set LLVMZ80EXE to llvm-z80 clang}"
: "${TMPDIR:?Set TMPDIR to a writable temporary directory}"
Z80_TEST_TMPDIR=${Z80_TEST_TMPDIR:-"$TMPDIR"}
export ZCC ZCCCFG LLVMZ80EXE Z80_TEST_TMPDIR
