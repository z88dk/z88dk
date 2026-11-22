Before z88dk v2.5, classic `-lm` in these recipes linked genmath (6-byte, sccz80). From v2.5, `-lm` links math32. A 6-byte rerun is `--genmath` or `--math48` with sccz80 or 80cc. zsdcc stores a 4-byte IEEE value. 8-byte Microsoft format is `--mbf64` with either compiler.

CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify correct result, compile for the zx spectrum target and
run in an emulator.

classic/zsdcc
zcc +zx -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DPRINTF dhry_1.c dhry_2.c -o dhry -lmath48 -lndos -create-app

(These compile settings were found to give the best result).

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/zsdcc
zcc +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DTIMER -D__Z88DK dhry_1.c dhry_2.c -o dhry.bin -m -lndos

sccz80/classic
zcc +test -vn -O2 -DTIMER -D__Z88DK dhry_1.c dhry_2.c -o dhry.bin -m -lndos

sccz80/classic/8085
zcc +test -clib=8085 -vn -O2 -DTIMER -D__Z88DK dhry_1.c dhry_2.c -o dhry.bin -m -lndos

80cc/classic
zcc +test -compiler=80cc -vn -O2 -DTIMER -D__Z88DK dhry_1.c dhry_2.c -o dhry.bin -m -lndos
# Z80 80cc best case: locals from the stack pointer.

80cc/classic/8085
zcc +test -clib=8085 -compiler=80cc -vn -O2 -DTIMER -D__Z88DK dhry_1.c dhry_2.c -o dhry.bin -m -lndos

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks dhry.bin -x dhry.map -start TIMER_START -end TIMER_STOP -counter 999999999999

For 8085 binaries add -m8085 before the binary:

z88dk-ticks -m8085 dhry.bin -x dhry.map -start TIMER_START -end TIMER_STOP -counter 999999999999

start   = TIMER_START
end     = TIMER_STOP
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK August 16, 2026
classic/zsdcc 4.6.0 #16639
7852 bytes less page zero

cycle count  = 246162688
time @ 4MHz  = 246162688 / 4x10^6 = 61.54 seconds
dhrystones/s = 20000 / 61.54 = 324.9883
DMIPS        = 324.9883 / 1757 = 0.1850

Z88DK November 8, 2026
sccz80 / classic c library
8366 bytes less page zero

cycle count  = 473021519
time @ 4MHz  = 473021519 / 4x10^6 = 118.26 seconds
dhrystones/s = 20000 / (473021519 / 4x10^6) = 169.1255
DMIPS        = 169.1255 / 1757 = 0.0963

Z88DK November 8, 2026
sccz80 / classic c library / 8085
7972 bytes less page zero

cycle count  = 385680196
time @ 4MHz  = 385680196 / 4x10^6 = 96.42 seconds
dhrystones/s = 20000 / (385680196 / 4x10^6) = 207.4257
DMIPS        = 207.4257 / 1757 = 0.1181

Z88DK November 8, 2026
80cc / classic c library
8159 bytes less page zero

cycle count  = 284380153
time @ 4MHz  = 284380153 / 4x10^6 = 71.10 seconds
dhrystones/s = 20000 / (284380153 / 4x10^6) = 281.3136
DMIPS        = 281.3136 / 1757 = 0.1601

Z88DK November 8, 2026
80cc / classic c library / 8085
7802 bytes less page zero

cycle count  = 287860112
time @ 4MHz  = 287860112 / 4x10^6 = 71.97 seconds
dhrystones/s = 20000 / (287860112 / 4x10^6) = 277.9128
DMIPS        = 277.9128 / 1757 = 0.1582
