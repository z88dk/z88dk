CHANGES TO SOURCE CODE
======================

WHETSTONE.C

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

Change:

#define DSIN   sinf
#define DCOS   cosf
#define DATAN  atanf
#define DLOG   logf
#define DEXP   expf
#define DSQRT  sqrtf

VERIFY CORRECT RESULT
=====================

SDCC does not have any character i/o built into its libraries.
We'll just have to trust that correct output is generated

SDCC's float type has a 24 bit mantissa so it's expected that
small errors will appear in the last decimal digit.

TIMING
======

sdcc -mz80 -DSTATIC -DTIMER --max-allocs-per-node200000 whetstone.c -o whetstone.ihx
hex2bin whetstone.ihx

TIMER_START = 0x022f
   0x025 (TIMER_START in whetstone.sym) -
   0x000 (_main in whetstone.sym) +
   0x20a (_main in whetstone.map)

TIMER_STOP = 0x1036
   0xe2c (TIMER_STOP in whetstone.sym) -
   0x000 (_main in whetstone.sym) +
   0x20a (_main in whetstone.map)

SIZE = 14379 bytes
   0x27fd (_CODE in whetstone.map) +
   0x0003 (_HEADER0 in whetstone.map) +
   0x0002 (_HEADER1 in whetstone.map) +
   0x0002 (_HEADER2 in whetstone.map) +
   0x0002 (_HEADER3 in whetstone.map) +
   0x0002 (_HEADER4 in whetstone.map) +
   0x0002 (_HEADER5 in whetstone.map) +
   0x0002 (_HEADER6 in whetstone.map) +
   0x0002 (_HEADER7 in whetstone.map) +
   0x000c (_HEADER8 in whetstone.map) +
   0x0f6f (_HOME in whetstone.map) +
   0x000f (_GSINIT in whetstone.map) +
   0x0001 (_GSFINAL in whetstone.map) +
   0x0092 (_DATA in whetstone.map)

The invocation of TICKS looked like this:

ticks whetstone.bin -start 022f -end 1036 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 3.6.5 #9842 (MINGW64)
24 bit mantissa + 8 bit exponent
14379 bytes less page zero

cycle count  = 2184812093
time @ 4MHz  = 2184812093 / 4x10^6 = 546.2030  seconds
KWIPS        = 100*10*1 / 546.2030 = 1.8308
MWIPS        = 1.8308 / 1000 = 0.0018308
