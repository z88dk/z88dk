CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas had to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

// comments replaced with /**/ comments.

After "include <math.h>" add:

typedef float float_t;
typedef float double_t;

Compiled with C309-15 from https://github.com/agn453/HI-TECH-Z80-C

VERIFY CORRECT RESULT
=====================

Enabling the optimizer causes Hitech to run out of memory.
The benchmark must be verified with the optimizer off unfortunately.

CC -V -N -DSTATIC -DPRINTOUT WHET.C -LF

Run WHET.COM to verify results.

Some of the tests had excessive error in the third decimal
digit.  Error for math libraries using a 24 bit mantissa is only
expected in the fifth decimal digit.

Hitech C CPM V309 is not producing correct results for this benchmark
but we'll run it anyway and mark the results with an asterisk to
indicate float math is unreliable.

TIMING
======

CC -V -N -OF -DSTATIC -MWHET.MAP WHET.C -LF

TOTAL       Name         Link     Load   Length
            (abs)           0        0        0
            text            0        0     1DDB
            data         1DDB     1DDB      504
            bss          22DF     22DF       95

SIZE = text + data + bss = 0x1DDB + 0x504 + 0x95 = 9076 bytes

z88dk-ticks WHET.COM -counter 999999999999

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-15
** INCORRECT RESULTS
24 bit mantissa + 8 bit exponent
9076 bytes exact

cycle count  = 646520995
time @ 4MHz  = 646520995 / 4*10^6 = 161.6302 sec
KWIPS        = 100*10*1 / 161.6302 = 6.187
MWIPS        = 6.187 / 1000 = 0.006187
