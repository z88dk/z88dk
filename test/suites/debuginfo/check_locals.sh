#!/bin/sh
# Drive z88dk-ticks over a -debug build of dbglocals.c and assert that the named
# locals the optimiser used to keep out of their frame slot (z88dk#3233) read
# their true value: a reassigned local whose readers were copy-propagated, a
# constant-initialised local, an int used only as a byte, a load/bit-op/store
# chain of named locals, a for-header counter,
# and on z80 a fastcall function whose whole frame is its pushed parameter and
# an __sdcccall(1) parameter copied into a slot.
#
# usage: check_locals.sh <ticks-machine-flag> <bin> <map> <label>
set -u

brk() { grep -n "BREAK $1:" dbglocals.c | cut -d: -f1; }

cmds="break dbglocals.c:$(brk twice)
break dbglocals.c:$(brk konst)
break dbglocals.c:$(brk narrow)
break dbglocals.c:$(brk rmw)
break dbglocals.c:$(brk count)
"
n=5
if [ "$4" = z80 ]; then
    cmds="${cmds}break dbglocals.c:$(brk fcb)
break dbglocals.c:$(brk sc1)
"
    n=7
fi
i=0
while [ $i -lt $n ]; do
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

want '<uint8_t>r = 7'       # twice: reassigned, readers copy-propagated
want '<uint8_t>loc = 3'     # konst: constant-initialised
want '<int16_t>t = 4660'    # narrow: an int only used as a byte keeps 2 bytes
want '<uint16_t>v = 4660'   # rmw: neither local of the chain is narrowed
want '<uint16_t>m = 4661'
want '<int16_t>n = '        # count: the for-header counter has a record
if [ "$label" = z80 ]; then
    want '<uint8_t>c = 9'   # fcb: the frame base survives a frame that is only the pushed param
    want '<uint16_t>a = 10' # sc1: __sdcccall(1) params, copied into slots
    want '<uint8_t>b = 5'
    want '<uint16_t>s = 15'
fi

if [ "$ok" != 1 ]; then
    echo "---- ticks output ($label) ----"
    echo "$out"
    echo "debuginfo locals FAIL ($label)"
    exit 1
fi
echo "debuginfo locals OK ($label)"
