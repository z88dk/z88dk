#!/bin/sh
# An unknown name inside an expression gives that name's error: ticks used to
# crash (arithmetic with * or /, a cast) or print "<void> <none>" (+ and -).
# Each expression runs in a session of its own, since a crash ends the session.
#
# usage: check_exprerr.sh <ticks-machine-flag> <bin> <map> <label>
set -u

BRK=19   # dbgvars.c break line (the `r = r + s;` statement — keep in sync)

label="$4"
ok=1
for expr in 'a - NOSUCH' 'NOSUCH + 1' 'a * NOSUCH' 'a / NOSUCH' '(int)NOSUCH' '(char)NOSUCH + 1'; do
    out=$(printf 'break dbgvars.c:%s\ncont\nprint %s\nprint a + b\nquit\n' "$BRK" "$expr" \
          | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)
    rc=$?
    echo "$out" | grep -qF 'Error: Cannot resolve symbol: NOSUCH' \
        || { echo "  MISSING [$label] print $expr: Error: Cannot resolve symbol: NOSUCH (rc=$rc)"; ok=0; }
    # the session survived: the next command still ran
    echo "$out" | grep -qF '$1 = <int16_t> 30' \
        || { echo "  MISSING [$label] print $expr: the next command, print a + b, did not run (rc=$rc)"; ok=0; }
done

if [ "$ok" != 1 ]; then
    echo "debuginfo exprerr FAIL ($label)"
    exit 1
fi
echo "debuginfo exprerr OK ($label)"
