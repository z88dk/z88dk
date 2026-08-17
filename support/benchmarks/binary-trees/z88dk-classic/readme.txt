CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result, compile for the zx target
and run on a spectrum emulator.

classic/sccz80/8085
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O2 --opt-code-speed binary-trees.c -o bt --math-mbf32 -lndos -create-app -pragma-define:CRT_HEAP_AMALLOC=1

classic/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 binary-trees.c -o bt --math-mbf32 -lndos -create-app -pragma-define:CRT_HEAP_AMALLOC=1

classic/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -compiler=sdcc -SO3 --max-allocs-per-node200000 binary-trees.c -o bt -lmath48 -lndos -create-app -pragma-define:CRT_HEAP_AMALLOC=1

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80/8085
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 --opt-code-speed binary-trees.c -o bt.bin --math-mbf32 -lndos -m -pragma-define:CRT_HEAP_AMALLOC=1

classic/sccz80
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 binary-trees.c -o bt.bin --math-mbf32 -lndos -m -pragma-define:CRT_HEAP_AMALLOC=1

classic/80cc
zcc +test -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O2 --opt-code-speed binary-trees.c -o bt.bin --math-mbf32 -lndos -m -pragma-define:CRT_HEAP_AMALLOC=1
# Do not add -fframe-pointer: mbf32 clobbers IX.

classic/80cc/8085
zcc +test -clib=8085 -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O2 --opt-code-speed binary-trees.c -o bt.bin --math-mbf32 -lndos -m -pragma-define:CRT_HEAP_AMALLOC=1

# 80cc PRINTF output matches the N=8 reference. TIMER remesured Aug 17, 2026.

classic/zsdcc
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 binary-trees.c -o bt.bin -lmath48 -lndos -m -pragma-define:CRT_HEAP_AMALLOC=1

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks bt.bin -x bt.map -start TIMER_START -end TIMER_STOP -counter 999999999999

For 8085 binaries add -m8085.

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK July 20, 2026
classic/sccz80/8085
3609 bytes less page zero

cycle count  = 127055600
time @ 4MHz  = 127055600 / 4*10^6 = 31.76 sec


Z88DK August 28, 2022
classic/sccz80
3800 bytes less page zero

cycle count  = 145563150
time @ 4MHz  = 145563150 / 4*10^6 = 36.39 sec


Z88DK August 16, 2026
classic / zsdcc 4.6.0 #16639
3538 bytes less page zero

cycle count  = 149280700
time @ 4MHz  = 149280700 / 4*10^6 =   37.3 sec


Z88DK August 17, 2026
classic/80cc
4036 bytes less page zero

cycle count  = 151405574
time @ 4MHz  = 151405574 / 4*10^6 = 37.85 sec


Z88DK August 17, 2026
classic/80cc/8085
3876 bytes less page zero

cycle count  = 150137083
time @ 4MHz  = 150137083 / 4*10^6 = 37.53 sec
