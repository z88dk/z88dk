CHANGES TO SOURCE CODE
======================

PI.C

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

SDCC does not have an ldiv() function.

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "pi.com" file can be run in a cpm emulator to verify results.

TIMING
======

sdcc -mz80 -DSTATIC -DTIMER --max-allocs-per-node200000 pi.c -o pi.ihx
hex2bin pi.ihx

TIMER_START = 0x217
   0x00d (TIMER_START in pi.sym) -
   0x000 (_main in pi.sym) +
   0x20a (_main in pi.map)

TIMER_STOP = 0x3c9
   0x1bf (TIMER_STOP in pi.sym) -
   0x000 (_main in pi.sym) +
   0x20a (_main in pi.map)

SIZE = 6844 bytes
   0x01eb (_CODE in pi.map) +
   0x0003 (_HEADER0 in pi.map) +
   0x0002 (_HEADER1 in pi.map) +
   0x0002 (_HEADER2 in pi.map) +
   0x0002 (_HEADER3 in pi.map) +
   0x0002 (_HEADER4 in pi.map) +
   0x0002 (_HEADER5 in pi.map) +
   0x0002 (_HEADER6 in pi.map) +
   0x0002 (_HEADER7 in pi.map) +
   0x000c (_HEADER8 in pi.map) +
   0x02b4 (_HOME in pi.map) +
   0x000f (_GSINIT in pi.map) +
   0x0001 (_GSFINAL in pi.map) +
   0x15f0 (_DATA in pi.map)

The invocation of TICKS looked like this:

ticks pi.bin -start 0217 -end 03c9 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 3.6.5 #9842 (MINGW64)
6844 bytes less page zero

cycle count  = 8700157418
time @ 4MHz  = 8700157418 / 4*10^6 = 36 min 15 sec
