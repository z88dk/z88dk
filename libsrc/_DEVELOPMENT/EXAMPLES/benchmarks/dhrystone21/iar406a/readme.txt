CHANGES TO SOURCE CODE
======================

DHRY.H

Add after "include <math.h>":

typedef float double_t;
typedef float float_t;

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s01.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "dhry.com" file can be run in a cpm emulator to verify results.
The number of runs should be entered as "1" followed by "CTRL+J".

TIMING
======

Return to the main directory.

Run the "Winmake.bat" batch file.  This time a bare binary is produced for
ORG 0.  Unlike such binaries produced by SDCC and Z88DK there is no page
zero code automatically generated.

The end of the compile summary file generated in "list/dhry.html" indicates
total program size:  3 + 1637 + 5731 = 7371

Timing points had to be identified manually by examining the output binary
with some help from the compile summary.

The invocation of TICKS looked like this:

ticks dhry.bin -start 0155 -end 02a4 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

IAR Z80 V4.06A
7371 bytes less small amount

cycle count  = 306860580
time @ 4MHz  = 306860580 / 4x10^6 = 76.7151  seconds
dhrystones/s = 20000 / 76.7151 = 260.7047
DMIPS        = 260.7047 / 1757 = 0.14838
