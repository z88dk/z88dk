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

Results are completely incorrect so HTC 750 does not have a
functioning float package.

TIMING
======

HTC V750 is disqualified because its results are completely incorrect.

RESULT
======

HITECH C MSDOS V750
** COMPLETELY INCORRECT RESULTS
24 bit mantissa + 8 bit exponent
7002 bytes exact
