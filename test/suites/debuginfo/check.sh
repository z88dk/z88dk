#!/bin/sh
# Drive z88dk-ticks over a -debug binary and assert the cdb frame info resolves
# each local/param to its true value. Proves debug-home locals land coherently
# in their slot and the ,B,1,d offsets match the code, for both the IX frame
# (z80) and the __debug_framepointer chain (8080/8085/gbz80).
#
# usage: check.sh <ticks-machine-flag> <bin> <map> <label>
set -u

BRK=19   # dbgvars.c break line (the `r = r + s;` statement — keep in sync)

out=$(printf 'break dbgvars.c:%s\ncont\ninfo locals\nquit\n' "$BRK" \
      | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)

label="$4"
ok=1
want() {
    echo "$out" | grep -qF "$1" || { echo "  MISSING [$label]: $1"; ok=0; }
}

want '<int16_t>a = 10'    # param
want '<int16_t>b = 20'    # param
want '<int16_t>s = 130'   # local, reassigned (30 -> +100)
want '<int16_t>p = 200'   # local
want '<int16_t>r = 330'   # local

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo FAIL ($label)"
    exit 1
fi
echo "debuginfo OK ($label)"
