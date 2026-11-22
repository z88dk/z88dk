CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s01.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "n-body.com" file can be run in a cpm emulator to verify results.

Results were all correct with only errors in the last decimal digit
which is expected for float types with 24-bit mantissa.

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-6)

TIMING
======

Return to the main directory.

Run the "Winmake.bat" batch file.  This time a bare binary is produced for
ORG 0.  Unlike such binaries produced by SDCC and Z88DK there is no page
zero code automatically generated.

The end of the compile summary file generated in "list/n-body.html" indicates
total program size:  3 + 3355 + 726 = 4084

Timing points had to be identified manually by examining the output binary
with some help from the compile summary.

The invocation of TICKS looked like this:

ticks n-body.bin -start 0b01 -end 0b56 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

IAR Z80 V4.06A
4084 bytes less small amount

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-6)

cycle count  = 2331516019
time @ 4MHz  = 2331516019 / 4*10^6 = 9 min 43 sec
