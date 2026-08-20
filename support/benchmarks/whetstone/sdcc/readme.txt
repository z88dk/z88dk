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
makebin -p whetstone.ihx whetstone.bin

TIMER_START = 0x21a
   0x010 (TIMER_START in whetstone.sym) -
   0x000 (_main in whetstone.sym) +
   0x20a (_main in whetstone.map)

TIMER_STOP = 0x9ca
   0x9d4 (TIMER_STOP in whetstone.sym) -
   0x000 (_main in whetstone.sym) +
   0x20a (_main in whetstone.map)

SIZE = 10364 bytes
   7076 (_CODE in whetstone.map) +
   3    (_HEADER0 in whetstone.map) +
   3    (_HEADER1 in whetstone.map) +
   3    (_HEADER2 in whetstone.map) +
   3    (_HEADER3 in whetstone.map) +
   3    (_HEADER4 in whetstone.map) +
   3    (_HEADER5 in whetstone.map) +
   3    (_HEADER6 in whetstone.map) +
   3    (_HEADER7 in whetstone.map) +
   16   (_HEADER8 in whetstone.map) +
   3170 (_HOME in whetstone.map) +
   37   (_GSINIT in whetstone.map) +
   1    (_GSFINAL in whetstone.map) +
   40   (_DATA in whetstone.map)

The invocation of TICKS looked like this:

z88dk-ticks whetstone.bin -start 021a -end 09ca -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 4.6.0 #16608 Linux
24 bit mantissa + 8 bit exponent
10364 bytes less page zero

cycle count  = 1850296726
time @ 4MHz  = 1850296726 / 4x10^6 = 462.5742 seconds
KWIPS        = 100*10*1 / 462.5742 = 2.1618
MWIPS        = 2.1618 / 1000 = 0.0021618
