CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result, we compiled for CPM we compiled
with all combinations of compiler and library under test:

new/sccz80
zcc +cpm -vn -DSTATIC -DPRINTF -DCOMMAND -O2 -clib=new binary-trees.c -o bt -lm -create-app

new/zsdcc
zcc +cpm -vn -DSTATIC -DPRINTF -DCOMMAND -SO3 -clib=sdcc_iy --max-allocs-per-node200000 binary-trees.c -o bt -lm -create-app

CPM was chosen as test target because it makes available a
large memory space for the heap.

Run the output BT.COM under emulation invoking with "BT 10"
so that the program reads N=10 from the command line.

Be sure to use a max speed CPM emulator because a real time
execution will take more than nine hours.

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/sccz80
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new binary-trees.c -o bt -lm -m -pragma-include:zpragma.inc -create-app

new/zsdcc
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 binary-trees.c -o bt -lm -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks bt.bin -start 08dc -end 0a40 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 2, 2017
ZSDCC #9833


new/zsdcc
2674 bytes less page zero

cycle count  = 132383340000
time @ 4MHz  = 132383340000 / 4*10^6 = 9 hrs 11 min 36 sec


new/sccz80
2816 bytes less page zero

cycle count  = MAY BE HANGING
time @ 4MHz  = NEED TO INVESTIGATE
