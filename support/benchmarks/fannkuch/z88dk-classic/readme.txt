CHANGES TO SOURCE CODE
======================

none.

VERIFY CORRECT RESULT
=====================

To verify the correct result, compile for the zx spectrum target and
run in a spectrum emulator.

classic/sccz80/8085
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O2 fannkuch.c -o fannkuch -lndos -create-app

classic/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 fannkuch.c -o fannkuch -lndos -create-app

classic/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -DINLINE -compiler=sdcc -SO3 --max-allocs-per-node200000 fannkuch.c -o fannkuch -lndos -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80/8085
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 --opt-code-speed fannkuch.c -o fannkuch.bin -lndos -m

classic/sccz80
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 fannkuch.c -o fannkuch.bin -lndos -m

classic/80cc
zcc +test -compiler=80cc -vn -fframe-pointer -DSTATIC -DTIMER -D__Z88DK -O2 --opt-code-speed fannkuch.c -o fannkuch.bin -lndos -m
# Z80 80cc: -fframe-pointer (IX).

classic/80cc/8085
zcc +test -clib=8085 -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O2 --opt-code-speed fannkuch.c -o fannkuch.bin -lndos -m

classic/zsdcc
zcc +test -vn -DSTATIC -DINLINE -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 fannkuch.c -o fannkuch.bin -lndos -m

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks fannkuch.bin -x fannkuch.map -start TIMER_START -end TIMER_STOP -counter 999999999999

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
1719 bytes less page zero

cycle count  = 67749895
time @ 4MHz  = 67749895 / 4*10^6 = 16.94 sec


Z88DK January 3, 2022
classic/sccz80
1763 bytes less page zero

cycle count  = 75381296
time @ 4MHz  = 75381296 / 4*10^6 = 18.84 sec


Z88DK August 19, 2026
classic/80cc
1871 bytes less page zero

cycle count  = 69027872
time @ 4MHz  = 69027872 / 4*10^6 =   17.3 sec


Z88DK August 19, 2026
classic/80cc/8085
1722 bytes less page zero

cycle count  = 64523364
time @ 4MHz  = 64523364 / 4*10^6 =   16.1 sec


Z88DK August 16, 2026
classic/zsdcc 4.6.0 #16639
2028 bytes less page zero

cycle count  = 62181357
time @ 4MHz  = 62181357 / 4*10^6 =   15.5 sec
