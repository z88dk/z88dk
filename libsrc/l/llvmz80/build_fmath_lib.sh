#!/bin/sh
# Build llvmz80_fmath.lib -- clang compiler-rt f32 float helper bridges for the
# z88dk classic target driven by -compiler=llvmz80, aliased onto z88dk's math32
# (IEEE-754 binary32) cores.  ravn/z88dk#44 (retire the f64 softfloat closure).
#
# Since `double`==`float`==32-bit binary32 on this target (float32-math32,
# ravn/llvm-z80#277), clang lowers all float/double work to the 32-bit `sf`
# libcalls.  This archive supplies the full family that a real float program
# emits, each a thin bridge over math32 (selected at link with --math32):
#   __addsf3.asm   -> ___addsf3 ___subsf3 ___mulsf3 ___divsf3   (arithmetic)
#   __cmpsf2.asm   -> ___cmpsf2 ___gtsf2 ___gesf2 ___unordsf2   (compares, incl
#                     the -ffast-math ___cmpsf2_fast variant)
#   __floatsisf.asm-> ___fixsfsi ___fixunssfsi ___floatsisf ___floatunsisf
#                     (float<->int conversions)
# zcc auto-links this archive for every -compiler=llvmz80 program (config var
# LLVMZ80FMATH, default DESTDIR/libsrc/l/llvmz80/llvmz80_fmath).  Because it is a
# .lib ARCHIVE the linker discards every unreferenced module, so an integer-only
# program pays zero bytes; the math32 cores (cm32_ / m32_compare) are only pulled
# when a float libcall is actually referenced, i.e. only when --math32 was passed.
#
# Reproducible: run from anywhere; z88dk-z80asm must be on PATH (or set Z80ASM).
# Output: llvmz80_fmath.lib next to this script.  The whole tree ignores
# **/*.lib (libsrc/.gitignore), so this artifact is committed with an explicit
# `git add -f` (host-independent z80 object code, ~3 KB) so the auto-link works
# cross-machine with no build step.  Re-run this script and `git add -f` after
# editing any bridge .asm.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
Z80ASM=${Z80ASM:-z88dk-z80asm}

command -v "$Z80ASM" >/dev/null 2>&1 || { echo "ERROR: $Z80ASM not on PATH"; exit 1; }

cd "$DIR"
rm -f llvmz80_fmath.lib __addsf3.o __cmpsf2.o __floatsisf.o
# -x=name creates name.lib from the listed sources; -mz80 = plain Z80.
"$Z80ASM" -mz80 -x=llvmz80_fmath __addsf3.asm __cmpsf2.asm __floatsisf.asm
rm -f __addsf3.o __cmpsf2.o __floatsisf.o
echo "built: $DIR/llvmz80_fmath.lib"
