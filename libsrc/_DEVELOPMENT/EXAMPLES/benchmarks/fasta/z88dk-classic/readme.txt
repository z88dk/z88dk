CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

classic/sccz80
zcc +zx-vn -DSTATIC -DPRINTF -O2 fasta.c -o fasta --math-mbf32 -lndos -pragma-define:USING_amalloc -create-app

classic/sccz80/8085
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O2 fasta.c -o fasta --math-mbf32_8085 -lndos -pragma-define:USING_amalloc -create-app

classic/sccz80/math32
zcc +cpm -vn -DSTATIC -DPRINTF -O2 fasta.c -o fasta --math32 -lndos -pragma-define:USING_amalloc -create-app

classic/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -compiler=sdcc --max-allocs-per-node200000 --fsigned-char fasta.c -o fasta -lmath48 -lndos -pragma-define:USING_amalloc -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80/MBF32
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 fasta.c -o fasta.bin -m --math-mbf32 -lndos -pragma-define:USING_amalloc

classic/sccz80/8085/MBF32
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 fasta.c -o fasta.bin -m --math-mbf32_8085 -lndos -pragma-define:USING_amalloc

classic/sccz80/math32
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 fasta.c -o fasta.bin -m --math32 -lndos -pragma-define:USING_amalloc

classic/zsdcc
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc --max-allocs-per-node200000 --fsigned-char fasta.c -o fasta.bin -m -lmath48 -lndos -pragma-define:USING_amalloc

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks fasta.bin -start 0546 -end 05bc -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 20, 2020
classic/zsdcc #11566
3583 bytes less page zero

cycle count  = 248331410
time @ 4MHz  = 248331410 / 4*10^6 = 62.08 sec


Z88DK January 5, 2022
classic/sccz80/8085/MBF32
4930 bytes less page zero

cycle count  = 215257269
time @ 4MHz  = 215257269 / 4*10^6 = 53.81 sec


Z88DK January 3, 2022
classic/sccz80/MBF32
4823 bytes less page zero

cycle count  = 165102454
time @ 4MHz  = 165102454 / 4*10^6 = 41.27 sec


Z88DK April 20, 2020
classic/sccz80/math32
3978 bytes less page zero

cycle count  = 136057474
time @ 4MHz  = 136057474 / 4*10^6 = 34.01 sec

