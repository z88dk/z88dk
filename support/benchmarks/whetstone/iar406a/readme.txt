CHANGES TO SOURCE CODE
======================

Add after "include <math.h>":

typedef float double_t;
typedef float float_t;

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s01.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "whet.com" file can be run in a cpm emulator to verify results.

Results were all correct with only errors in the last decimal digit
which is expected for float types with 24-bit mantissa.

TIMING
======

Return to the main directory.

Run the "Winmake.bat" batch file.  This time a bare binary is produced for
ORG 0.  Unlike such binaries produced by SDCC and Z88DK there is no page
zero code automatically generated.

The end of the compile summary file generated in "list/whet.html" indicates
total program size:  3 + 5863 + 658 = 6524

Timing points had to be identified manually by examining the output binary
with some help from the compile summary.

The invocation of TICKS looked like this:

ticks whet.bin -start 0654 -end 0d20 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

IAR Z80 V4.06A
24 bit mantissa + 8 bit exponent
6524 bytes less small amount

cycle count  = 732360277
time @ 4MHz  = 732360277 / 4*10^6 = 183.0901 seconds
KWIPS        = 100*10*1 / 183.0901 = 5.4618
MWIPS        = 5.4618 / 1000 = 0.0054618
