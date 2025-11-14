CHANGES TO SOURCE CODE
======================

To create a larger heap, add:
#include "heap.c"

Change "iterations = pow(2, maxDepth - depth + minDepth);"
to "iterations = pow(2, maxDepth - depth + minDepth) + 0.5;"

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s01.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "bt.com" file can be run in a cpm emulator to verify results.

TIMING
======

Return to the main directory.

Run the "Winmake.bat" batch file.  This time a bare binary is produced for
ORG 0.  Unlike such binaries produced by SDCC and Z88DK there is no page
zero code automatically generated.

The end of the compile summary file generated in "list/bt.html" indicates
total program size:  3 + 3978 + 544 (20k heap is not included) = 4525

Timing points had to be identified manually by examining the output binary
with some help from the compile summary.

The invocation of TICKS looked like this:

ticks bt.bin -start 06c6 -end 07b6 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

IAR Z80 V4.06A
4525 bytes less small amount

cycle count  = 7358336547
time @ 4MHz  = 7358336547 / 4x10^6 = 30 min 40 sec
