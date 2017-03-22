CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

Using IDE HPDZ.EXE make a new project containing SPECTRAL.C.
Choose CP/M target and no optimization.

Under "MAKE->CPP pre-defined symbols" add -DSTATIC -DPRINTF
Build the program, ignoring warnings as they come up.

Select float formats for printf.

Run on a cpm emulator to verify results.

INCORRECT RESULTS

TIMING
======

Change options to produce a ROM binary file.
Enable -DSTATIC only for CPP pre-defined symbols.

Rebuild to produce SPECTRAL.BIN.

Program size from the IDE dialog is: ? (ROM) + ? (RAM) = ? bytes.
The two other sections correspond to page zero and initialization code.

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks spectral.bin -start ???? -end ???? -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C MSDOS V750
? bytes exact

Disqualified due to incorrect results.
