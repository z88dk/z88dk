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

After "#include <math.h>" add "#define sqrt sqrtf"

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "n-body.com" file can be run in a cpm emulator to verify results.

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

TIMING
======

Change back to the main directory.

sdcc -mz80 -DSTATIC -DTIMER --max-allocs-per-node200000 n-body.c
hex2bin n-body.ihx

TIMER_START = 0x0d83
   0xb79 (TIMER_START in n-body.sym) -
   0xb79 (_main in n-body.sym) +
   0x0d83 (_main in n-body.map)

TIMER_STOP = 0x0dcc
   0xbc2 (TIMER_STOP in n-body.sym) -
   0xb79 (_main in n-body.sym) +
   0x0d83 (_main in n-body.map)

SIZE = 7141 bytes
   4329 (_CODE in n-body.map) +
   3 (_HEADER0 in n-body.map) +
   3 (_HEADER1 in n-body.map) +
   3 (_HEADER2 in n-body.map) +
   3 (_HEADER3 in n-body.map) +
   3 (_HEADER4 in n-body.map) +
   3 (_HEADER5 in n-body.map) +
   3 (_HEADER6 in n-body.map) +
   3 (_HEADER7 in n-body.map) +
   12 (_HEADER8 in n-body.map) +
   2384 (_HOME in n-body.map) +
   140 (_INITIALIZER in n-body.map) +
   37 (_GSINIT in n-body.map) +
   1 (_GSFINAL in n-body.map) +
   74 (_DATA in n-body.map) +
   140 (_INITIALIZED in n-body.map)

The invocation of TICKS looked like this:

z88dk-ticks n-body.bin -start 0d8e -end 0dcc -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 4.2.0 Linux
7141 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 3163137393
time @ 4MHz  = 3163137393 / 4*10^6 = 13 min 11 sec
