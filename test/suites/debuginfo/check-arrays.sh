#!/bin/sh
# Drive z88dk-ticks over dbgarr.c and assert every array sized by its
# initialiser reads back with its final size, and that the map carries no
# unsized ({-1}) record for a variable.
#
# usage: check-arrays.sh <bin> <map>
set -u

out=$(printf 'break main\ncont\nprint gs\nprint fs\nprint ss\nprint ca\nprint cb\nquit\n' \
      | z88dk-ticks -w 30 -d -mz80 -x "$2" "$1" 2>&1)

ok=1
want() {
    echo "$out" | grep -qF "$1" || { echo "  MISSING: $1"; ok=0; }
}

want '[5] = { [0] = 103, [1] = 108, [2] = 111, [3] = 98, [4] = 0 }'      # gs   "glob"
want '[5] = { [0] = 102, [1] = 105, [2] = 108, [3] = 101, [4] = 0 }'     # fs   "file"
want '[5] = { [0] = 115, [1] = 116, [2] = 97, [3] = 116, [4] = 0 }'      # ss   "stat"
want '[4] = { [0] = 97, [1] = 98, [2] = 99, [3] = 0 }'                  # ca   "abc"
want '[3] = { [0] = 100, [1] = 101, [2] = 0 }'                          # cb   "de"

# {-1} is encoded as _7b_2d_31_7d in a __CDBINFO__ symbol name
unsized=$(grep -c '__CDBINFO__S_.*_7b_2d_31_7d' "$2")
if [ "$unsized" != 0 ]; then
    echo "  $unsized unsized variable record(s) in $2"
    ok=0
fi

if [ "$ok" != 1 ]; then
    echo "---- ticks output ----"
    echo "$out"
    echo "debuginfo arrays FAIL"
    exit 1
fi
echo "debuginfo arrays OK"
