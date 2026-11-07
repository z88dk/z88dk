#!/bin/sh
# Drive z88dk-ticks over a -debug build of dbglongenum_a.c + dbglongenum_b.c,
# compiled by an absolute path long enough that the enum key F<file>$<tag>
# passes 256 characters, and assert that `print XV` gives the value of the
# file being debugged in both files, and that two locals of the same name in
# two functions of one file each print their own enum.
#
# usage: check_longenum.sh <ticks-machine-flag> <bin> <map> <directory> <label>
set -u

brk() { grep -n "BREAK $1:" dbglongenum_$2.c | cut -d: -f1; }

out=$(printf 'break %s/dbglongenum_b.c:%s\nbreak %s/dbglongenum_a.c:%s\nbreak %s/dbglongenum_b.c:%s\nbreak %s/dbglongenum_b.c:%s\ncont\nprint XV\ncont\nprint v\ncont\nprint v\ncont\nprint XV\nquit\n' \
          "$4" "$(brk b b)" "$4" "$(brk a a)" "$4" "$(brk h1 b)" "$4" "$(brk h2 b)" \
      | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)
rc=$?

label="$5"
ok=1
want() {
    echo "$out" | grep -qF "$1" || { echo "  MISSING [$label]: $1"; ok=0; }
}

[ "$rc" = 0 ] || { echo "  ticks exited with $rc [$label]"; ok=0; }
want '$1 = <int16_t> 2'     # in dbglongenum_b.c: its own XV
want '$2 = <enum ca> BLUE'  # h1's v
want '$3 = <enum cb> TWO'   # h2's v
want '$4 = <int16_t> 1'     # in dbglongenum_a.c: its own XV

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo longenum FAIL ($label)"
    exit 1
fi
echo "debuginfo longenum OK ($label)"
