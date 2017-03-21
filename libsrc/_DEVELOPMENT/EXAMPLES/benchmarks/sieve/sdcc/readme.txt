CHANGES TO SOURCE CODE
======================

SIEVE.C

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
The resulting "sieve.com" file can be run in a cpm emulator to verify results.

TIMING
======

sdcc -mz80 -DSTATIC -DTIMER --max-allocs-per-node200000 sieve.c -o sieve.ihx
hex2bin sieve.ihx

TIMER_START = 0x217
   0x00d (TIMER_START in sieve.sym) -
   0x000 (_main in sieve.sym) +
   0x20a (_main in sieve.map)

TIMER_STOP = 0x2b3
   0x0a9 (TIMER_STOP in sieve.sym) -
   0x000 (_main in sieve.sym) +
   0x20a (_main in sieve.map)

SIZE = 8263 bytes
   0x00d2 (_CODE in sieve.map) +
   0x0003 (_HEADER0 in sieve.map) +
   0x0002 (_HEADER1 in sieve.map) +
   0x0002 (_HEADER2 in sieve.map) +
   0x0002 (_HEADER3 in sieve.map) +
   0x0002 (_HEADER4 in sieve.map) +
   0x0002 (_HEADER5 in sieve.map) +
   0x0002 (_HEADER6 in sieve.map) +
   0x0002 (_HEADER7 in sieve.map) +
   0x000c (_HEADER8 in sieve.map) +
   0x000f (_GSINIT in sieve.map) +
   0x0001 (_GSFINAL in sieve.map) +
   0x1f48 (_DATA in sieve.map)

The invocation of TICKS looked like this:

ticks sieve.bin -start 0217 -end 02b3 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 3.6.5 #9842 (MINGW64)
8263 bytes less page zero

cycle count  = 4701570
time @ 4MHz  = 4701570 / 4*10^6 = 1.1754 sec
