#!/bin/sh
# Build llvmz80_imath.lib -- clang compiler-rt integer helper bridges for the
# z88dk newlib target driven by -compiler=llvmz80 (-clib=newlib_ix / newlib_iy).
#
# clang-z80 lowers runtime 16/32-bit mul/div/mod to gcc-style libcalls
# (__mulhi3/__umodhi3/__divsi3/__modsi3/__divmodsi4/__udivmodsi4 ...).  newlib
# does not export those names, and the classic libsrc/l/llvmz80 bridge objects
# are tied to classic-clib build context (config_private.inc).  These two
# newlib copies are self-contained thin adapters that call the l_div[su]/l_mulu
# *_16_16x16 / *_32_32x32 cores that are ALREADY bundled in the newlib archive,
# so the lib pulls in on demand with no classic clib.
#
# Reproducible: run from anywhere; z88dk-z80asm must be on PATH (or set Z80ASM).
# Output: llvmz80_imath.lib next to this script.  The whole tree ignores
# **/*.lib (libsrc/.gitignore), so this artifact is committed with an explicit
# `git add -f`.  It is tiny (~3 KB) and host-independent z80 object code, so a
# committed copy lets -clib=newlib_iy/newlib_ix link cross-machine without a
# build step.  Re-run this script and `git add -f` after editing any bridge.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
Z80ASM=${Z80ASM:-z88dk-z80asm}

command -v "$Z80ASM" >/dev/null 2>&1 || { echo "ERROR: $Z80ASM not on PATH"; exit 1; }

cd "$DIR"
rm -f llvmz80_imath.lib __divhi3.o __divsi3.o __udivqi3.o __mulsi3.o __memmove_rt.o
# -x=name creates name.lib from the listed sources; -mz80 = plain Z80.
#   __divhi3 = 16-bit div/mod/mul   __divsi3 = 32-bit div/mod (+ fused divmod)
#   __udivqi3 = 8-bit div/mod (-Os/-Oz)   __mulsi3 = 32-bit multiply
#   __memmove_rt = runtime-unknown-direction memmove bridge (-> asm_memmove)
"$Z80ASM" -mz80 -x=llvmz80_imath __divhi3.asm __divsi3.asm __udivqi3.asm __mulsi3.asm __memmove_rt.asm
rm -f __divhi3.o __divsi3.o __udivqi3.o __mulsi3.o __memmove_rt.o
echo "built: $DIR/llvmz80_imath.lib"
