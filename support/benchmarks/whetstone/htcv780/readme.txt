CHANGES TO SOURCE CODE
======================

After "include <math.h>" add:

typedef float float_t;
typedef float double_t;

VERIFY CORRECT RESULT
=====================

Using IDE HPDZ.EXE create a new project containing WHET.C.
Choose CP/M target with no optimizations enabled and enable float printf.

Under "MAKE->CPP pre-defined symbols" add -DSTATIC -DPRINTOUT.
Build the program, ignoring warnings as they come up.

Run on a cpm emulator to verify results.

HI-TECH C's float type has a 24 bit mantissa so it's expected that
small errors will appear in the last decimal digit.

TIMING
======

Change options to produce a ROM binary file.
Enable -DSTATIC and -DTIMER only for CPP pre-defined symbols.

Rebuild to produce WHETSTONE.BIN.

Program size from the IDE dialog is: 6750 (ROM) + 169 (RAM) = 6919 bytes.
The two other sections correspond to page zero and initialization code.

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

z88dk-ticks spectral.bin -start 10C -end 8D8 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C MSDOS V780pl2
24 bit mantissa + 8 bit exponent
6919 bytes exact

cycle count  = 614748605
time @ 4MHz  = 614748605 / 4x10^6 = 153.6871 seconds
KWIPS        = 100*10*1 / 153.6871 = 6.5067
MWIPS        = 6.5067 / 1000 = 0.0065067
