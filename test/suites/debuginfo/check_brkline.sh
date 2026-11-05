#!/bin/sh
# A breakpoint on the line of addp (brkline.c), which also has a file-scope
# C_LINE at crt0_init, stops in addp; one on the line of twice, which addp's
# end shares at the same address, stops in twice. Both read the parameter.
#
# usage: check_brkline.sh <bin> <map> <label>
set -u

bin="$1"
map="$2"
label="$3"
ok=1
out=""

for want in '12 _addp 41' '14 _twice 42'; do
    set -- $want
    o=$(printf 'break brkline.c:%s\ncont\ninfo locals\nquit\n' "$1" \
        | z88dk-ticks -w 30 -d -mz80 -x "$map" "$bin" 2>&1)
    out="$out
$o"
    echo "$o" | grep -qE "Hit breakpoint 1: @[0-9a-f]+ \\($2[+)]" \
        || { echo "  line $1: no stop in $2 [$label]"; ok=0; }
    echo "$o" | grep -qF "<int16_t>v = $3" || { echo "  line $1: MISSING v = $3 [$label]"; ok=0; }
done

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo brkline FAIL ($label)"
    exit 1
fi
echo "debuginfo brkline OK ($label)"
