Before z88dk v2.5, newlib `-lm` in these recipes linked math48 (6-byte). From v2.5, `-lm` links math32. A 6-byte rerun is `--math48` with sccz80 or 80cc (zsdcc still stores 4-byte IEEE). 8-byte Microsoft format is `--mbf64` with either compiler.

CHANGES TO SOURCE CODE
======================

none.

VERIFY CORRECT RESULT
=====================

To verify the correct result, compile for the zx spectrum target and
run in a spectrum emulator.

new/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -startup=5 -O2 -clib=new binary-trees.c -o bt -lm -create-app

new/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -startup=5 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 binary-trees.c -o bt -lm -create-app

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

z88dk-ticks bt.bin -start 0908 -end 0a80 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK October 14, 2026
new/sccz80
7707 bytes less page zero

cycle count  = 389283490
time @ 4MHz  = 389283490 / 4*10^6 = 1 min 37.32 sec

malloc searches an address-ordered free list of spare tails. Removing a
tail splices the node from the links it already holds. In-place realloc
still compares the next header. Same source and compiler against the
previous allocator: 6578438820 cycles. The free-list allocator before
this size pass was 394509309 cycles and 7795 bytes less page zero.


Z88DK October 14, 2026
new/zsdcc 4.6.0 #16639
7705 bytes less page zero

cycle count  = 388921443
time @ 4MHz  = 388921443 / 4*10^6 = 1 min 37.23 sec

Measured on the free-list allocator before the size pass above.
z88dk-zsdcc was not available to retime that pass. The assembler
sources are shared with the sccz80 library.
