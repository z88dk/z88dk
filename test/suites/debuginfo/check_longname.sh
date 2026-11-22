#!/bin/sh
# Drive z88dk-ticks over a -debug build of dbglongname.c and assert that the
# locals, a file static and a static local of a struct with a 126-character tag
# resolve in a function with a 100-character name, and that an unknown name
# there is an error; and that pick(), whose type names the long tag, has its
# parameter. The unknown name has 100 characters, so the static-local name ticks
# builds for it (st_<function>_<name>) is 204 characters long.
#
# usage: check_longname.sh <ticks-machine-flag> <bin> <map> <source path> <label>
set -u

brk() { grep -n "BREAK $1" dbglongname.c | cut -d: -f1; }

out=$(printf 'break %s:%s\nbreak %s:%s\ncont\ninfo locals\nprint gt\nprint lt.m2\nprint sl\nprint uzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\ncont\ninfo locals\nquit\n' \
          "$4" "$(brk f)" "$4" "$(brk p)" \
      | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)
rc=$?

label="$5"
ok=1
want() {
    echo "$out" | grep -qF "$1" || { echo "  MISSING [$label]: $1"; ok=0; }
}

[ "$rc" = 0 ] || { echo "  ticks exited with $rc [$label]"; ok=0; }
want '<int16_t>x = 3'                   # the parameter
want '>lt = {m1=3, m2=17}'              # a local of the long-tag struct
want '> {m1=5, m2=6}'                   # gt, the file static
want '$2 = <int16_t> 17'                # lt.m2
want '$3 = <int16_t> 11'                # sl, the static local
want '<int16_t>i = 1'                   # pick: its function record parsed
want 'Error: Cannot resolve symbol: uzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo longname FAIL ($label)"
    exit 1
fi
echo "debuginfo longname OK ($label)"
