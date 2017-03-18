CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result, compile for the zx target
and run on a spectrum emulator.

classic/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 binary-trees.c -o bt -lm -lndos -lmalloc -create-app -pragma-define:USING_amalloc

classic/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -compiler=sdcc -SO3 --max-allocs-per-node200000 binary-trees.c -o bt -lmath48 -lndos -lmalloc -create-app -pragma-define:USING_amalloc

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 binary-trees.c -o bt.bin -lm -lndos -lmalloc -m -pragma-define:USING_amalloc

classic/zsdcc
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 binary-trees.c -o bt.bin -lmath48 -lndos -lmalloc -m -pragma-define:USING_amalloc

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks bt.bin -start 0214 -end 0391 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 18, 2017
classic/sccz80
2852 bytes less page zero

cycle count  = 159135288
time @ 4MHz  = 159135288 / 4*10^6 = 39.78 sec


Z88DK March 18, 2017
classic / zsdcc #9852
2910 bytes less page zero

cycle count  = 151251680
time @ 4MHz  = 151251680 / 4*10^6 = 37.81 sec
