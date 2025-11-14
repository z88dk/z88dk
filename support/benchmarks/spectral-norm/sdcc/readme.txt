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
The resulting "spectral.com" file can be run in a cpm emulator to verify results.

error: 5 * 10^(-6)

TIMING
======

Change back to the main directory.

sdcc -mz80 -DSTATIC -DTIMER --max-allocs-per-node200000 spectral-norm.c
hex2bin spectral-norm.ihx

TIMER_START = 0x428
   0x21e(TIMER_START in spectral-norm.sym) -
   0x214 (_main in spectral-norm.sym) +
   0x41e (_main in spectral-norm.map)

TIMER_STOP = 0x53d
   0x333 (TIMER_STOP in spectral-norm.sym) -
   0x214 (_main in spectral-norm.sym) +
   0x41e (_main in spectral-norm.map)

SIZE = 6013 bytes
   2165 (_CODE in spectral-norm.map) +
   3    (_HEADER0 in spectral-norm.map) +
   3    (_HEADER1 in spectral-norm.map) +
   3    (_HEADER2 in spectral-norm.map) +
   3    (_HEADER3 in spectral-norm.map) +
   3    (_HEADER4 in spectral-norm.map) +
   3    (_HEADER5 in spectral-norm.map) +
   3    (_HEADER6 in spectral-norm.map) +
   3    (_HEADER7 in spectral-norm.map) +
   12   (_HEADER8 in spectral-norm.map) +
   2554 (_HOME in spectral-norm.map) +
   37   (_GSINIT in spectral-norm.map) +
   1    (_GSFINAL in spectral-norm.map) +
   1220 (_DATA in spectral-norm.map)

The invocation of TICKS looked like this:

z88dk-ticks spectral-norm.bin -start 0428 -end 053d -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 4.2.0 Linux
6013 bytes less page zero

error: 5 * 10^(-6)

cycle count  = 15739496039
time @ 4MHz  = 15739496039 / 4*10^6 = 65 min 35 sec
