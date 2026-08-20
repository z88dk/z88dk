CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify correct result, compile for the zx spectrum target
and run in an emulator.

classic/sccz80/8085
zcc +cpm -clib=8085 -vn -O2 -DSTATIC -DPRINTF pi.c -o pi -lndos -create-app

sccz80/classic
zcc +zx -vn -O2 -DSTATIC -DPRINTF pi.c -o pi -lndos -create-app

zsdcc/classic
zcc +zx -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DPRINTF pi.c -o pi -lndos -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80/8085
zcc +test -clib=8085 -vn -O2 -DSTATIC -DTIMER -D__Z88DK pi.c -o pi.bin -lndos -m

sccz80/classic
zcc +test -vn -O2 -DSTATIC -DTIMER -D__Z88DK pi.c -o pi.bin -lndos -m

80cc/classic
zcc +test -compiler=80cc -vn -fframe-pointer -O2 -DSTATIC -DTIMER -D__Z88DK pi.c -o pi.bin -lndos -m
# Z80 80cc: -fframe-pointer (IX).

80cc/classic/8085
zcc +test -clib=8085 -compiler=80cc -vn -O2 -DSTATIC -DTIMER -D__Z88DK pi.c -o pi.bin -lndos -m

zsdcc/classic
zcc +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK pi.c -o pi.bin -lndos -m

In each case, the map file was used to look up symbols "TIMER_START"
and "TIMER_STOP".  These address bounds were given to TICKS to measure
execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks pi.bin -x pi.map -start TIMER_START -end TIMER_STOP -counter 9999999999

For 8085 binaries add -m8085.

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

PI.C


Z88DK August 19, 2026
sccz80 / classic c library / 8085 CPU
7390 bytes less page zero

cycle count  = 1922636057
time @ 4MHz  = 1922636057 / 4*10^6 =  8 min  1 sec


Z88DK August 19, 2026
sccz80 / classic c library
7252 bytes less page zero

cycle count  = 1992348390
time @ 4MHz  = 1992348390 / 4*10^6 =  8 min 18 sec


Z88DK August 19, 2026
80cc / classic c library
7718 bytes less page zero

cycle count  = 2229596893
time @ 4MHz  = 2229596893 / 4*10^6 =  9 min 17 sec


Z88DK August 19, 2026
80cc / classic c library / 8085 CPU
7639 bytes less page zero

cycle count  = 1979531647
time @ 4MHz  = 1979531647 / 4*10^6 =  8 min 15 sec


Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic c library
7175 bytes less page zero

cycle count  = 4012863322
time @ 4MHz  = 4012863322 / 4*10^6 =  16 min 43 sec
