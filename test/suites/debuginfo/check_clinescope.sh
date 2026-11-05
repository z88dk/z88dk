#!/bin/sh
# Each line of clinescope.c that holds code of two blocks has a C_LINE for
# each (80cc), so the scope of both blocks' code is known; a breakpoint on such
# a line goes to its first code.
#
# usage: check_clinescope.sh <asm from -a -debug> <bin> <map>
set -u

asm="$1"
label=80cc
ok=1

# the distinct scopes of the C_LINEs of line $1, one per line
scopes() {
    grep -oE "C_LINE[[:space:]]+$1,\"clinescope\.c::f::[0-9]+::[0-9]+\"" "$asm" \
        | sed -E 's/.*::(f::[0-9]+::[0-9]+)"/\1/' | LC_ALL=C sort -u
}

# each scope named must be among the line's
for want in '17 f::1::1' '17 f::2::2' '20 f::2::3' '20 f::1::1' '21 f::2::4' '21 f::2::5'; do
    line=${want%% *}
    scopes "$line" | grep -qxF "${want#* }" \
        || { echo "  C_LINE $line: no ${want#* } in '$(scopes "$line" | tr '\n' ' ')' [$label]"; ok=0; }
done
# the statement and the for of line 22 are at two levels (the for's block number
# depends on whether the for opens a block of its own)
n=$(scopes 22 | wc -l)
[ "$n" -ge 2 ] || { echo "  C_LINE 22: $n scope(s), want 2 or more [$label]"; ok=0; }

# a C_LINE is written only when the line or the scope changes
dup=$(grep -E 'C_LINE[[:space:]]+[0-9]+,"clinescope\.c::' "$asm" | uniq -d)
[ -z "$dup" ] || { echo "  repeated C_LINE: $dup [$label]"; ok=0; }

# line 17's first code is the if test, which runs although the block does not;
# line 20's is g += z, before t++
out=$(printf 'break clinescope.c:17\ncont\ninfo locals\nquit\n' \
      | z88dk-ticks -w 30 -d -mz80 -x "$3" "$2" 2>&1)
for want in 'Hit breakpoint 1' '<int16_t>t = 1'; do
    echo "$out" | grep -qF "$want" || { echo "  MISSING [$label]: $want"; ok=0; }
done
out20=$(printf 'break clinescope.c:20\ncont\nprint g\nquit\n' \
      | z88dk-ticks -w 30 -d -mz80 -x "$3" "$2" 2>&1)
for want in 'Hit breakpoint 1' '= <int16_t> 0'; do
    echo "$out20" | grep -qF "$want" || { echo "  MISSING [$label] (line 20): $want"; ok=0; }
done
out="$out
$out20"

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo clinescope FAIL ($label)"
    exit 1
fi
echo "debuginfo clinescope OK ($label)"
