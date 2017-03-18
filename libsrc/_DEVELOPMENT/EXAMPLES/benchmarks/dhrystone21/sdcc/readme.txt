CHANGES TO SOURCE CODE
======================

DHRY.H

Add after "include <math.h>":

typedef float double_t;
typedef float float_t;

Change:

#ifdef TIMER
   #define TIMER_START()       __asm__("TIMER_START:")
   #define TIMER_STOP()        __asm__("TIMER_STOP:")
#else
   #define TIMER_START()
   #define TIMER_STOP()
#endif

During compile these assembly labels will cause warnings about
z80instructionSize() failing.  This happens because the optimizer thinks
the labels are instructions.  These can be safely ignored.

DHRY_1.C

Replace 'scanf ("%d", &Number_Of_Runs);' with "Number_Of_Runs = 1;"
sdcc does not supply the scanf side of stdio.

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "dhry.com" file can be run in a cpm emulator to verify results.

TIMING
======

sdcc -mz80 -DNOSTRUCTASSIGN -DTIMER --max-allocs-per-node200000 -c dhry_1.c
sdcc -mz80 -DNOSTRUCTASSIGN -DTIMER --max-allocs-per-node200000 -c dhry_2.c
sdcc -mz80 dhry_1.rel dhry_2.rel -o dhry.ihx
hex2bin dhry.ihx

TIMER_START = 0x278
   0x06e (TIMER_START in dhry_1.sym) -
   0x000 (_main in dhry_1.sym) +
   0x20a (_main in dhry.map)

TIMER_STOP = 0x3f3
   0x1e9 (TIMER_STOP in dhry_1.sym) -
   0x000 (_main in dhry_1.sym) +
   0x20a (_main in dhry.map)

SIZE = 7073 bytes
   0x071c (_CODE in dhry.map) +
   0x0003 (_HEADER0 in dhry.map) +
   0x0002 (_HEADER1 in dhry.map) +
   0x0002 (_HEADER2 in dhry.map) +
   0x0002 (_HEADER3 in dhry.map) +
   0x0002 (_HEADER4 in dhry.map) +
   0x0002 (_HEADER5 in dhry.map) +
   0x0002 (_HEADER6 in dhry.map) +
   0x0002 (_HEADER7 in dhry.map) +
   0x000c (_HEADER8 in dhry.map) +
   0x0002 (_INITIALIZER in dhry.map) +
   0x000f (_GSINIT in dhry.map) +
   0x0001 (_GSFINAL in dhry.map) +
   0x1454 (_DATA in dhry.map) +
   0x0002 (_INITIALIZED in dhry.map)

The invocation of TICKS looked like this:

ticks dhry.bin -start 0278 -end 03f3 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 3.6.5 #9842 (MINGW64)
7013 bytes less page zero

cycle count  = 292880320
time @ 4MHz  = 292880320 / 4x10^6 = 73.22008  seconds
dhrystones/s = 20000 / 73.2208 = 273.1464
DMIPS        = 273.1464 / 1757 = 0.15546
