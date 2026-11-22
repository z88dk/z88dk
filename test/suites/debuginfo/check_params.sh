#!/bin/sh
# Drive z88dk-ticks over a -debug build of dbgparams.c and assert that a
# parameter the function reassigns reads its current value at a later
# breakpoint (z88dk#3233): a byte parameter, a fastcall parameter, a
# callee-cleanup parameter and a long parameter.
#
# usage: check_params.sh <ticks-machine-flag> <bin> <map> <label>
set -u

brk() { grep -n "BREAK $1:" dbgparams.c | cut -d: -f1; }

cmds="break dbgparams.c:$(brk addp)
break dbgparams.c:$(brk fcp)
break dbgparams.c:$(brk cal)
break dbgparams.c:$(brk lp)
"
i=0
while [ $i -lt 4 ]; do
    cmds="${cmds}cont
info locals
"
    i=$((i + 1))
done

out=$(printf '%squit\n' "$cmds" | z88dk-ticks -w 30 -d "$1" -x "$3" "$2" 2>&1)

label="$4"
ok=1
want() {
    echo "$out" | grep -qF "$1" || { echo "  MISSING [$label]: $1"; ok=0; }
}

want '<uint8_t>a = 3'       # addp: reassigned byte parameter
want '<uint8_t>x = 7'       # fcp: fastcall parameter
want '<uint8_t>a = 15'      # cal: callee-cleanup parameter
want '<uint32_t>x = 74568'  # lp: long parameter

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo params FAIL ($label)"
    exit 1
fi
echo "debuginfo params OK ($label)"
