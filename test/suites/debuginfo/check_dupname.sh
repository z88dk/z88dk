#!/bin/sh
# Two modules with the same file name (dupname/dup1/dup.c, dupname/dup2/dup.c)
# define different enums with the same tag, so their N: records have the same key
# (N:Fdup.c$e), as file statics of same-named modules already collide. The first
# record read (the map is sorted by name, so link order does not decide) keeps the
# key; the second is not added as a duplicate key, and marks the key ambiguous:
# objects of either enum print their value as a number. The first enum's
# enumerators still resolve, the second's do not. The values overlap on purpose
# (B = D = 2), so a reader that just picked one enum would print a wrong name.
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

want '$1 = <enum e> 2'             # g1: B, but the key is ambiguous
want '$2 = <enum e> 2'             # g2: D, the same
want '$3 = <int16_t> 1'            # A
want 'Error: Cannot resolve symbol: C'

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo dupname FAIL ($label)"
    exit 1
fi
echo "debuginfo dupname OK ($label)"
