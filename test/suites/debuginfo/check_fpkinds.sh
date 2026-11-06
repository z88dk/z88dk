#!/bin/sh
# Every module writes the float format, once, whatever it declares: compile
# floats_kinds.c with each -D and count __fp_mode in the asm.
#
# usage: check_fpkinds.sh <compiler>
set -u

ok=1
for k in GLOBAL FILE_STATIC ARRAY POINTER MEMBER LOCAL LOCAL_STATIC PARAM RETURN \
         EXTERN PROTOTYPE SELF_POINTER NESTED_PTR PTR_ARRAY NONE; do
    zcc +test -vn -compiler="$1" -D$k -a floats_kinds.c -o "fpkinds_$1_$k.asm" || { echo "  compile failed [$1 $k]"; ok=0; continue; }
    n=$(grep -c '^	defc	__fp_mode = ' "fpkinds_$1_$k.asm")
    [ "$n" = 1 ] || { echo "  WRONG [$1 $k]: $n __fp_mode, want 1"; ok=0; }
done

if [ "$ok" != 1 ]; then
    echo "debuginfo fpkinds FAIL ($1)"
    exit 1
fi
echo "debuginfo fpkinds OK ($1)"
