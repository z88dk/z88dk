CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s01.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "spectral.com" file can be run in a cpm emulator to verify results.

error: 1 * 10^(-6)

TIMING
======

Return to the main directory.

Run the "Winmake.bat" batch file.  This time a bare binary is produced for
ORG 0.  Unlike such binaries produced by SDCC and Z88DK there is no page
zero code automatically generated.

The end of the compile summary file generated in "list/spectral.html" indicates
total program size:  3 + 2222 + 1732 = 3957

Timing points had to be identified manually by examining the output binary
with some help from the compile summary.

The invocation of TICKS looked like this:

ticks spectral.bin -start 06a0 -end 0765 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

IAR Z80 V4.06A
3957 bytes less small amount

error: 1 * 10^(-6)

cycle count  = 8632065790
time @ 4MHz  = 8632065790 / 4*10^6 = 35 min 58 sec
