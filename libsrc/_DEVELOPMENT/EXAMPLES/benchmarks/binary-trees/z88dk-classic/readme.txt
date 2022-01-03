CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result, compile for the zx target
and run on a spectrum emulator.

classic/sccz80/8085
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O2 binary-trees.c -o bt --math-mbf32_8085 -lndos -create-app -pragma-define:USING_amalloc

classic/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 binary-trees.c -o bt --math-mbf32 -lndos -create-app -pragma-define:USING_amalloc

classic/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -compiler=sdcc -SO3 --max-allocs-per-node200000 binary-trees.c -o bt -lmath48 -lndos -create-app -pragma-define:USING_amalloc

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80/8085
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 binary-trees.c -o bt.bin --math-mbf32_8085 -lndos -m -pragma-define:USING_amalloc

classic/sccz80
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 binary-trees.c -o bt.bin --math-mbf32 -lndos -m -pragma-define:USING_amalloc

classic/zsdcc
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 binary-trees.c -o bt.bin -lmath48 -lndos -m -pragma-define:USING_amalloc

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks bt.bin -start 0214 -end 0391 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK January 3, 2022
classic/sccz80/8085
3831 bytes less page zero

cycle count  = 156017339
time @ 4MHz  = 156017339 / 4*10^6 = 39.00 sec


Z88DK January 3, 2022
classic/sccz80
3800 bytes less page zero

cycle count  = 145559470
time @ 4MHz  = 145559470 / 4*10^6 = 36.39 sec


Z88DK April 20, 2020
classic / zsdcc #11566
2978 bytes less page zero

cycle count  = 150508687
time @ 4MHz  = 150508687 / 4*10^6 = 37.63 sec
