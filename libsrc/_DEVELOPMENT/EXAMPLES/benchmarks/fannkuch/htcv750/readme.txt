CHANGES TO SOURCE CODE
======================

Change the name of the function "INLINE static int max(int a, int b)"
to "INLINE static int maxi(int a, int b)".  Hitech C already has
a function defined named "max".

VERIFY CORRECT RESULT
=====================

Using IDE HPDZ.EXE make a new project containing FANNKUCH.C.
Choose CP/M target and max optimizations with global optimization = 9.
Select long printf under options.

Under "MAKE->CPP pre-defined symbols" add -DSTATIC -DPRINTF
Build the program, ignoring warnings as they come up.

Run on a cpm emulator to verify results.

TIMING
======

Change options to produce a ROM binary file.
Enable -DSTATIC only for CPP pre-defined symbols.

Rebuild to produce FANNKUCH.BIN.

Program size from the IDE dialog is: 574 (ROM) + 142 (RAM) = 716 bytes.
The two other sections correspond to page zero and initialization code.

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks fannkuch.bin -start 0311 -end 0316 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C MSDOS V750
716 bytes exact

cycle count  = 49858382
time @ 4MHz  = 49858382 / 4x10^6 = 12.46 seconds
