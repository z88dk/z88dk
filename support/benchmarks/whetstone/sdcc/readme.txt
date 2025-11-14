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

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "whetston.com" file can be run in a cpm emulator to verify results.

SDCC's float type has a 24 bit mantissa so it's expected that
small errors will appear in the last decimal digit.

TIMING
======

sdcc -mz80 -DTIMER --max-allocs-per-node200000 whetstone.c -o whetstone.ihx
hex2bin whetstone.ihx

TIMER_START = 0x0232
   0x010 (TIMER_START in whetstone.sym) -
   0x000 (_main in whetstone.sym) +
   0x20a (_main in whetstone.map)

TIMER_STOP = 0x0bde
   0x9d4 (TIMER_STOP in whetstone.sym) -
   0x000 (_main in whetstone.sym) +
   0x20a (_main in whetstone.map)

SIZE = 10935 bytes
   7897 (_CODE in whetstone.map) +
   3    (_HEADER0 in whetstone.map) +
   3    (_HEADER1 in whetstone.map) +
   3    (_HEADER2 in whetstone.map) +
   3    (_HEADER3 in whetstone.map) +
   3    (_HEADER4 in whetstone.map) +
   3    (_HEADER5 in whetstone.map) +
   3    (_HEADER6 in whetstone.map) +
   3    (_HEADER7 in whetstone.map) +
   12   (_HEADER8 in whetstone.map) +
   2924 (_HOME in whetstone.map) +
   37   (_GSINIT in whetstone.map) +
   1    (_GSFINAL in whetstone.map) +
   40   (_DATA in whetstone.map)

The invocation of TICKS looked like this:

z88dk-ticks whetstone.bin -start 021a -end 0bde -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 4.2.0 Linux
24 bit mantissa + 8 bit exponent
10935 bytes less page zero

cycle count  = 1491668242
time @ 4MHz  = 1491668242 / 4x10^6 = 372.9170 seconds
KWIPS        = 100*10*1 / 372.9170 = 2.6816
MWIPS        = 2.6816 / 1000 = 0.0026816
