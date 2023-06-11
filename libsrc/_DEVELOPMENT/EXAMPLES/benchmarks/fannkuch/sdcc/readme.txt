CHANGES TO SOURCE CODE
======================

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

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "fannkuch.com" file can be run in a cpm emulator to verify results.

TIMING
======

Change back to the main directory.

sdcc -mz80 -DINLINE -DTIMER --max-allocs-per-node200000 fannkuch.c
hex2bin fannkuch.ihx

TIMER_START = 0x492
   0x288 (TIMER_START in fannkuch.sym) -
   0x288 (_main in fannkuch.sym) +
   0x492 (_main in fannkuch.map)

TIMER_STOP = 0x498
   0x28e (TIMER_STOP in fannkuch.sym) -
   0x288 (_main in fannkuch.sym) +
   0x492 (_main in fannkuch.map)

SIZE = 962 bytes
   792  (_CODE in fannkuch.map) +
   3    (_HEADER0 in fannkuch.map) +
   3    (_HEADER1 in fannkuch.map) +
   3    (_HEADER2 in fannkuch.map) +
   3    (_HEADER3 in fannkuch.map) +
   3    (_HEADER4 in fannkuch.map) +
   3    (_HEADER5 in fannkuch.map) +
   3    (_HEADER6 in fannkuch.map) +
   3    (_HEADER7 in fannkuch.map) +
   12   (_HEADER8 in fannkuch.map) +
   37   (_GSINIT in fannkuch.map) +
   1    (_GSFINAL in fannkuch.map) +
   96   (_DATA in fannkuch.map)

The invocation of TICKS looked like this:

z88dk-ticks fannkuch.bin -start 0492 -end 0498 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 4.2.0 Linux
962 bytes less page zero

cycle count  = 57325388
time @ 4MHz  = 57325388 / 4*10^6 = 14.33 sec
