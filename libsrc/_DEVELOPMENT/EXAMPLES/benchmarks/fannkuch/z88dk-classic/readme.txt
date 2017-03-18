CHANGES TO SOURCE CODE
======================

none.

VERIFY CORRECT RESULT
=====================

To verify the correct result, compile for the zx spectrum target and
run in a spectrum emulator.

classic/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 fannkuch.c -o fannkuch -lndos -create-app

classic/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -DINLINE -compiler=sdcc -SO3 --max-allocs-per-node200000 fannkuch.c -o fannkuch -lndos -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 fannkuch.c -o fannkuch.bin -lndos -m

classic/zsdcc
zcc +test -vn -DSTATIC -DINLINE -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 fannkuch.c -o fannkuch.bin -lndos -m

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks fannkuch.bin -start 033e -end 0345 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 18, 2017
classic/sccz80
1236 bytes less page zero

cycle count  = 90501905
time @ 4MHz  = 90501905 / 4*10^6 = 22.63 sec


Z88DK March 18, 2017
classic/zsdcc #9852
1386 bytes less page zero

cycle count  = 63620883
time @ 4MHz  = 63620883 / 4*10^6 = 15.91 sec
