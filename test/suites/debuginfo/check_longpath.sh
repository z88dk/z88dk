#!/bin/sh
# Drive z88dk-ticks over a -debug build of dbglongpath.c compiled by an absolute
# path long enough that <file>.<function>.<local> passes 128 characters, and
# assert that the map loads and the locals, the static function's locals and
# the file static all resolve.
#
# usage: check_longpath.sh <ticks-machine-flag> <bin> <map> <source path> <label>
set -u

brk() { grep -n "BREAK $1:" dbglongpath.c | cut -d: -f1; }

out=$(printf 'break %s:%s\nbreak %s:%s\ncont\ninfo locals\ncont\ninfo locals\nprint gs\nquit\n' \
          "$4" "$(brk twice)" "$4" "$(brk main)" \
      | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)
rc=$?

label="$5"
ok=1
want() {
    echo "$out" | grep -qF "$1" || { echo "  MISSING [$label]: $1"; ok=0; }
}

[ "$rc" = 0 ] || { echo "  ticks exited with $rc [$label]"; ok=0; }
want '<int16_t>x = 7'       # twice: parameter
want '<int16_t>y = 14'      # twice: local
want '<int16_t>a = 7'       # main: local
want '<int16_t>b = 4'       # main: local
want '$1 = <int16_t> 9'     # gs: file static

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo longpath FAIL ($label)"
    exit 1
fi
echo "debuginfo longpath OK ($label)"
