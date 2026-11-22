CHANGES TO SOURCE CODE
======================

In both PI.C and PI_LDIV.C replace "include <stdint.h>" with:

typedef unsigned int  uint16_t;
typedef unsigned long uint32_t;

VERIFY CORRECT RESULTS
======================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s01.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "pi.com" and "pi-ldiv.com" files can be run in a cpm emulator
to verify results.

TIMING
======

Return to the main directory.

Run the "Winmake.bat" batch file.  This time bare binaries are produced for
ORG 0.  Unlike such binaries produced by SDCC and Z88DK there is no page
zero code automatically generated.

The end of the compile summary file generated in "list/pi.html" indicates
total program size:  3 + 658 + 6128 = 6789 for PI.C.

The end of the compile summary file generated in "list/pi_ldiv.html" indicates
total program size:  3 + 867 + 6136 = 7006 for PI_LDIV.C.

Timing points had to be identified manually by examining the output binary
with some help from the compile summary.

The invocations of TICKS looked like this:

ticks pi.bin -start 01a4 -end 0290 -counter 9999999999
ticks pi-ldiv.bin -start 01de -end 02e7 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

PI.C

IAR Z80 V4.06A
6789 bytes less small amount

cycle count  = 8762223085
time @ 4MHz  = 8762223085 / 4*10^6 = 36 min 31 sec

PI_LDIV.C

IAR Z80 V4.06A
7006 bytes less small amount

cycle count  = 8799503282
time @ 4MHz  = 8799503282 / 4*10^6 = 36 min 40 sec

It appears that IAR implements ldiv() as two separate divisions.
