CHANGES TO SOURCE CODE
======================

none.

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s01.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "fasta.com" file can be run in a cpm emulator to verify results.

TIMING
======

Return to the main directory.

Run the "Winmake.bat" batch file.  This time a bare binary is produced for
ORG 0.  Unlike such binaries produced by SDCC and Z88DK there is no page
zero code automatically generated.

The end of the compile summary file generated in "list/fasta.html" indicates
total program size:  3 + 3328 + 2710 = 6041

Timing points had to be identified manually by examining the output binary
with some help from the compile summary.

The invocation of TICKS looked like this:

ticks fasta.bin -start 08ee -end 094d -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

IAR Z80 V4.06A
6041 bytes less small amount

cycle count  = 223805149
time @ 4MHz  = 223805149 / 4x10^6 = 55.95 sec
