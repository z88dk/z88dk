#!/bin/sh
# Two modules with the same file name (dupname/dup1/dup.c, dupname/dup2/dup.c)
# define different enums with the same tag, so their N: records have the same key
# (N:Fdup.c$e). The first record read is the enum; the second is ignored, not
# added to the table as a duplicate key. An object of the ignored enum prints its
# value as a number; the linker pulls dup1 in before dup2.
#
# usage: check_dupname.sh <ticks-machine-flag> <bin> <map> <label>
set -u

out=$(printf 'break main\ncont\nprint g1\nprint g2\nprint A\nprint C\nquit\n' \
      | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)

label="$4"
ok=1
want() {
    echo "$out" | grep -qF "$1" || { echo "  MISSING [$label]: $1"; ok=0; }
}

want '$1 = <enum e> B'             # g1: the first enum e
want '$2 = <enum e> 4'             # g2: D = 4, not in the first enum e
want '$3 = <int16_t> 1'            # A
want 'Error: Cannot resolve symbol: C'

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo dupname FAIL ($label)"
    exit 1
fi
echo "debuginfo dupname OK ($label)"
