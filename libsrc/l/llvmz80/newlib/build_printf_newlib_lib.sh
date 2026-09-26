#!/bin/sh
# Build llvmz80_printf_newlib.lib -- the nanoprintf-backed IEEE-754 printf shim
# (__llvmz80_printf/_fprintf/_sprintf/_snprintf/_vfprintf) for the z88dk NEWLIB
# target driven by -compiler=llvmz80 (-clib=newlib_iy / newlib_ix).
#
# WHY A NEWLIB-SPECIFIC COPY OF THE SHIM
#   The same shim source (llvmz80-softfloat/src/npf_printf.c) is packaged into
#   the classic softfloat_cpm_z80.lib (LLVMZ80RTLIB), but that object is compiled
#   against the CLASSIC clib headers, where `stdout` and `putchar` are macros
#   that bake in the classic stdio internals (`_sgoioblk`).  Those symbols do
#   not exist on the newlib target, so the classic shim object cannot link on
#   newlib (undefined `__sgoioblk`).  This lib is the SAME source compiled
#   against the NEWLIB headers, so its stdout/putchar/fputc resolve to newlib's.
#
#   The f64 SoftFloat cores (__adddf3/__muldf3/... + the split-out __mulsi3) stay
#   in the shared softfloat_cpm_z80.lib, which auto-links on BOTH routes via
#   LLVMZ80RTLIB (zcc appends it for any -compiler=llvmz80 link).  The newlib_iy
#   CLIB lists THIS lib before the archive, so z80asm resolves the __llvmz80_*
#   printf entries here and never pulls the archive's classic shim.
#
# DEPENDENCY: the shim + nanoprintf sources live in the sibling llvmz80-softfloat
#   repo (they ship with the clang binary, compiler-rt style).  Point
#   SOFTFLOAT_ROOT at it (default: <workspace>/llvmz80-softfloat).
#
# Reproducible: needs zcc (-compiler=llvmz80) + z88dk-z80asm on PATH.  Output:
#   llvmz80_printf_newlib.lib next to this script.  The tree ignores **/*.lib
#   (libsrc/.gitignore), so the artifact is committed with an explicit
#   `git add -f`.  Re-run + `git add -f` after editing npf_printf.c.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
# workspace root = .../z88dk/libsrc/l/llvmz80/newlib -> up 5 -> workspace
WS=$(cd "$DIR/../../../../.." && pwd)
SOFTFLOAT_ROOT=${SOFTFLOAT_ROOT:-"$WS/llvmz80-softfloat"}
Z80ASM=${Z80ASM:-z88dk-z80asm}

command -v zcc >/dev/null 2>&1 || { echo "ERROR: zcc not on PATH"; exit 1; }
command -v "$Z80ASM" >/dev/null 2>&1 || { echo "ERROR: $Z80ASM not on PATH"; exit 1; }
[ -f "$SOFTFLOAT_ROOT/src/npf_printf.c" ] || {
    echo "ERROR: npf_printf.c not found under SOFTFLOAT_ROOT=$SOFTFLOAT_ROOT"; exit 1; }

cd "$DIR"
rm -f llvmz80_printf_newlib.lib npf_printf.o

# Compile the shim against the NEWLIB headers (-clib=newlib_iy) so stdout/putchar
# /fputc bind to newlib's stdio, not classic's _sgoioblk.
zcc +cpm -clib=newlib_iy -Cg-O2 \
    -I"$SOFTFLOAT_ROOT/src" -I"$SOFTFLOAT_ROOT/vendor/nanoprintf" -I"$SOFTFLOAT_ROOT/vendor/config" \
    -c -o npf_printf.o "$SOFTFLOAT_ROOT/src/npf_printf.c"

"$Z80ASM" -mz80 -x=llvmz80_printf_newlib npf_printf.o
rm -f npf_printf.o
echo "built: $DIR/llvmz80_printf_newlib.lib"
