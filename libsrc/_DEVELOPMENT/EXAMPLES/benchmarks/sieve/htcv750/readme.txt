CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

Using IDE HPDZ.EXE make a new project containing SIEVE.C.
Choose CP/M target and max optimizations with global optimization = 9.

Under "MAKE->CPP pre-defined symbols" add -DSTATIC -DPRINTF.
Build the program, ignoring warnings as they come up.

Run on a cpm emulator to verify results.

TIMING
======

Change options to produce a ROM binary file.
Enable -DSTATIC only for CPP pre-defined symbols.

Rebuild to produce SIEVE.BIN.

Program size from the IDE dialog is: 199 (ROM) + 8044 (RAM) = 8243
The two other sections correspond to page zero and initialization code.

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks sieve.bin -start 0102 -end 0191 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C MSDOS V750
8243 bytes exact

cycle count  = 3672107
time @ 4MHz  = 3672107 / 4x10^6 = 0.9180 seconds
