#!/bin/sh
# The level and block of f's locals in forblk.c are forblk.records, for sccz80
# and 80cc alike: each for has a block of its own (#3254). 80cc's for headers
# (init, test, step) carry the for's block, at the level 80cc already gave them,
# and the code after the loops is back in the function's block.
# ticks reads i and j at the first stop in the inner loop.
#
# usage: check_forblk.sh <asm from -a -debug> <bin> <map> <label>
set -u

label="$4"
ok=1

got=$(grep -oE '^; S:Lforblk\.c\.f\$[a-z]+\$[0-9]+_0\$[0-9]+' "$1" | sed 's/^; S:Lforblk\.c\.//' | LC_ALL=C sort)
if [ "$got" != "$(cat forblk.records)" ]; then
    echo "  local records differ from forblk.records [$label]:"
    echo "$got" | diff forblk.records - | sed 's/^/    /'
    ok=0
fi

if [ "$label" = 80cc ]; then
    for want in '19 f::2::3' '23 f::2::6' '25 f::1::1'; do
        line=${want%% *}
        got=$(grep -oE "C_LINE[[:space:]]+$line,\"forblk\.c::f::[0-9]+::[0-9]+\"" "$1" \
              | sed -E 's/.*::(f::[0-9]+::[0-9]+)"/\1/' | sort -u)
        [ "$got" = "${want#* }" ] || { echo "  C_LINE $line: got '$got', want '${want#* }' [$label]"; ok=0; }
    done
fi

out=$(printf 'break forblk.c:21\ncont\ninfo locals\nquit\n' \
      | z88dk-ticks -w 30 -d -mz80 -x "$3" "$2" 2>&1)
for want in '<int16_t>i = 1' '<int16_t>j = 2' '<int16_t>t = 2'; do
    echo "$out" | grep -qF "$want" || { echo "  MISSING [$label]: $want"; ok=0; }
done

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo forblk FAIL ($label)"
    exit 1
fi
echo "debuginfo forblk OK ($label)"
