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

TIMER_STOP = 0x2ab
   0x0a1 (TIMER_STOP in sieve.sym) -
   0x000 (_main in sieve.sym) +
   0x20a (_main in sieve.map)

SIZE = 8278 bytes
   196  (_CODE in sieve.map) +
   3    (_HEADER0 in sieve.map) +
   3    (_HEADER1 in sieve.map) +
   3    (_HEADER2 in sieve.map) +
   3    (_HEADER3 in sieve.map) +
   3    (_HEADER4 in sieve.map) +
   3    (_HEADER5 in sieve.map) +
   3    (_HEADER6 in sieve.map) +
   3    (_HEADER7 in sieve.map) +
   12   (_HEADER8 in sieve.map) +
   37   (_GSINIT in sieve.map) +
   1    (_GSFINAL in sieve.map) +
   8008 (_DATA in sieve.map)

The invocation of TICKS looked like this:

z88dk-ticks sieve.bin -start 0217 -end 02ab -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 4.2.0 Linux
8278 bytes less page zero

cycle count  = 4219481
time @ 4MHz  = 4219481 / 4*10^6 = 1.0548 sec
