CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s01.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting com files can be run in a cpm emulator to verify results.

TIMING
======

Return to the main directory.

Run the "Winmake.bat" batch file.  This time a bare binaries are produced for
ORG 0.  Unlike such binaries produced by SDCC and Z88DK there is no page
zero code automatically generated.

Program size is taken from the largest of the 20-number sorts.
The end of the compile summary file generated in "list/sr20.html" indicates
total program size:  3 + 1205 + 560 = 1768

Timing points had to be identified manually by examining the output binaries
with some help from the compile summary.  The qsort invocation was located
such that its position would not change much from compile to compile.

A typical invocation of TICKS looked like this:

ticks sr20.bin -start 00f6 -end 010d -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

IAR Z80 V4.06A
1768 bytes less small amount

               cycle count    time @ 4MHz

sort-ran-20         277760     0.0694 sec
sort-ord-20         170327     0.0426 sec
sort-rev-20         241931     0.0605 sec
sort-equ-20         389227     0.0973 sec

sort-ran-5000    228101043    57.0253 sec
sort-ord-5000     94750857    23.6877 sec
sort-rev-5000    124100937    31.0252 sec
sort-equ-5000  13597091697    56 min 39 sec

IAR contains a naive implementation of quicksort
that stumbles on the equal items edge case.
