#!/bin/sh
# Two sibling blocks declare a local `blk` of different enums (enums_blk.c). Their
# records differ only in the block number; each E: record pairs with its own S:
# record, as `info locals` shows (both blocks share the stack slot, so the first
# block's colour reads 2, the value the second block stored: no enumerator).
# `print blk` is not asserted: ticks does not resolve a name by block yet.
#
# usage: check_enumblk.sh <ticks-machine-flag> <bin> <map> <label>
set -u

LINE=16   # the second block (keep in sync)

out=$(printf 'break enums_blk.c:%s\ncont\ninfo locals\nquit\n' "$LINE" \
      | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)

label="$4"
ok=1
want() {
    echo "$out" | grep -qF "$1" || { echo "  MISSING [$label]: $1"; ok=0; }
}

want '<enum shared>blk = SH_TWO'    # the second block's blk
want '<enum colour>blk = 2'         # the first block's

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo enumblk FAIL ($label)"
    exit 1
fi
echo "debuginfo enumblk OK ($label)"
