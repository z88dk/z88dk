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

VERIFY CORRECT RESULT
=====================

Enabling the optimizer causes Hitech to run out of memory.
The benchmark must be compiled with the optimizer off unfortunately.

C -V -LF -DSTATIC -DPRINTOUT WHET.C

Run WHET.COM to verify results.

Some of the tests had excessive error into the third decimal
digit.  Error for math libraries using a 24 bit mantissa is only
expected in the fifth decimal digit.

Two of the tests produced incorrect results off by 10-30%.

Hitech C CPM V309 is not producing correct results for this benchmark
but we'll run it anyway and mark the results with an asterisk to
indicate float math is unreliable.

TIMING
======

C -V -LF -DSTATIC -MWHET.MAP WHET.C

Program size can be determined from information in the
map file.

SIZE = text + data + bss = 0x1b84 + 0x19e + 0x93 = 7605 bytes

CP/M COM files begin at address 0x100.  To time with TICKS
this needs to be embedded into a binary that starts at
address 0.  Bytes leading up to 0x100 are zeroes, meaning NOP.

appmake +rom -s 32768 -f 0 -o whet0.bin
appmake +inject -b whet0.bin -i WHET.COM -s 256 -o whet.bin

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks whet.bin -start 0155 -end 0136 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309
** INCORRECT RESULTS
24 bit mantissa + 8 bit exponent
7605 bytes less cpm overhead

cycle count  = 639413871
time @ 4MHz  = 639413871 / 4*10^6 = 159.8535 sec
KWIPS        = 100*10*1 / 159.8535 = 6.2557
MWIPS        = 6.2557 / 1000 = 0.0062557
