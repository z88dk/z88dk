#!/bin/sh
# Drive z88dk-ticks over floats_r.c (-debug), whose floats the float library computes
# at run time, and assert that they read in the module's format.
#
# usage: check_floats_run.sh <ticks-machine-flag> <bin> <map> <label> <library>
set -u

LINE=16     # floats_r.c: main()'s return (keep in sync)

label="$4"
ok=1
out=$(printf 'break floats_r.c:%s\ncont\nprint gr_a\nprint gr_b\nprint gr_c\nprint gr_arr[1]\nprint *gr_ptr\nprint gr_arr\nprint gr_floor\nprint gr_ceil\nquit\n' "$LINE" \
      | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)
for w in '$1 = <float> -3.250000' '$2 = <float> -6.000000' '$3 = <float> -0.003250' \
         '$4 = <float> 36.000000' '$5 = <float> 36.000000' '[2] = { [0] = 0.000000, [1] = 36.000000 }' \
         '$7 = <float> 2.000000'; do
    printf '%s\n' "$out" | grep -qF "$w" || { echo "  MISSING [$label]: $w"; ok=0; }
done

# ceil(-2.2): the mbf32 library gives -1 (its own bug, read right as -1)
if [ "$5" != mbf32 ]; then
    printf '%s\n' "$out" | grep -qF '$8 = <float> -2.000000' || { echo "  MISSING [$label]: \$8 = <float> -2.000000"; ok=0; }
fi

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo floats run FAIL ($label)"
    exit 1
fi
echo "debuginfo floats run OK ($label)"
