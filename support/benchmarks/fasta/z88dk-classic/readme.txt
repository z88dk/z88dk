CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

classic/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 fasta.c -o fasta --math-mbf32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1 -create-app

classic/sccz80/8085/MBF32
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O2 fasta.c -o fasta --math-mbf32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1 -create-app

classic/sccz80/math32
zcc +cpm -vn -DSTATIC -DPRINTF -O2 fasta.c -o fasta --math32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1 -create-app

classic/sccz80/8085/math32
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O2 fasta.c -o fasta --math32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1 -create-app

classic/80cc/math32
zcc +test -compiler=80cc -vn -DSTATIC -DPRINTF -O2 fasta.c -o fasta --math32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1

classic/80cc/8085/math32
zcc +test -clib=8085 -compiler=80cc -vn -DSTATIC -DPRINTF -O2 fasta.c -o fasta --math32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1

classic/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -compiler=sdcc --max-allocs-per-node200000 --fsigned-char fasta.c -o fasta -lmath48 -lndos -pragma-define:CRT_HEAP_AMALLOC=1 -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80/MBF32
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 fasta.c -o fasta.bin -m --math-mbf32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1

classic/sccz80/8085/MBF32
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 fasta.c -o fasta.bin -m --math-mbf32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1

classic/sccz80/math32
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 fasta.c -o fasta.bin -m --math32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1

classic/sccz80/8085/math32
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 fasta.c -o fasta.bin -m --math32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1

classic/80cc/math32
zcc +test -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O2 fasta.c -o fasta.bin -m --math32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1

classic/80cc/8085/math32
zcc +test -clib=8085 -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O2 fasta.c -o fasta.bin -m --math32 -lndos -pragma-define:CRT_HEAP_AMALLOC=1

classic/zsdcc
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc --max-allocs-per-node200000 --fsigned-char fasta.c -o fasta.bin -m -lmath48 -lndos -pragma-define:CRT_HEAP_AMALLOC=1

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks fasta.bin -x fasta.map -start TIMER_START -end TIMER_STOP -counter 999999999999

For 8085 binaries add -m8085.

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


Z88DK July 20, 2026
classic/sccz80/8085/MBF32
4811 bytes less page zero

cycle count  = 194305817
time @ 4MHz  = 194305817 / 4*10^6 = 48.58 sec


Z88DK July 19, 2026
classic/sccz80/MBF32
4796 bytes less page zero

cycle count  = 165734164
time @ 4MHz  = 165734164 / 4*10^6 = 41.43 sec


Z88DK July 19, 2026
classic/sccz80/math32
4582 bytes less page zero

cycle count  = 122328869
time @ 4MHz  = 122328869 / 4*10^6 = 30.58 sec


Z88DK July 20, 2026
classic/sccz80/8085/math32
5639 bytes less page zero

cycle count  = 186704695
time @ 4MHz  = 186704695 / 4*10^6 = 46.68 sec


Z88DK July 20, 2026
classic/80cc/math32
6664 bytes less page zero

cycle count  = 273699521
time @ 4MHz  = 273699521 / 4*10^6 = 68.42 sec


Z88DK July 20, 2026
classic/80cc/8085/math32
8177 bytes less page zero

cycle count  = 530674851
time @ 4MHz  = 530674851 / 4*10^6 = 132.67 sec
