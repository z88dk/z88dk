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
makebin -p dhry.ihx dhry.bin

TIMER_START = 0x26f
   0x065 (TIMER_START in dhry_1.sym) -
   0x000 (_main in dhry_1.sym) +
   0x20a (_main in dhry.map)

TIMER_STOP = 0x384
   0x180 (TIMER_STOP in dhry_1.sym) -
   0x000 (_main in dhry_1.sym) +
   0x20a (_main in dhry.map)

SIZE = 6774 bytes
   1486 (_CODE in dhry.map) +
   3    (_HEADER0 in dhry.map) +
   3    (_HEADER1 in dhry.map) +
   3    (_HEADER2 in dhry.map) +
   3    (_HEADER3 in dhry.map) +
   3    (_HEADER4 in dhry.map) +
   3    (_HEADER5 in dhry.map) +
   3    (_HEADER6 in dhry.map) +
   3    (_HEADER7 in dhry.map) +
   16   (_HEADER8 in dhry.map) +
   2    (_HOME in dhry.map) +
   2    (_INITIALIZER in dhry.map) +
   37   (_GSINIT in dhry.map) +
   1    (_GSFINAL in dhry.map) +
   5204 (_DATA in dhry.map) +
   2    (_INITIALIZED in dhry.map)

The invocation of TICKS looked like this:

z88dk-ticks dhry.bin -start 026f -end 0384 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 4.6.0 #16608 Linux
6774 bytes less page zero

cycle count  = 274542684
time @ 4MHz  = 274542684 / 4x10^6 = 68.6357 seconds
dhrystones/s = 20000 / 68.6357 = 291.393
DMIPS        = 291.393 / 1757 = 0.16585
