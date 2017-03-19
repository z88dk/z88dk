CHANGES TO SOURCE CODE
======================

Change "char *alu = ..." to "char alu[] = ..."

HTC will generate a string that is too long to be processed
by its assembler without the change.

VERIFY CORRECT RESULT
=====================

Using IDE HPDZ.EXE make a new project containing FASTA.C.
Choose CP/M target and max optimizations with global optimization = 9.

Under "MAKE->CPP pre-defined symbols" add -DSTATIC -DPRINTF
Build the program, ignoring warnings as they come up.

Run on a cpm emulator to verify results.  The compile fails
due to incorrect results in the "THREE Homo sapiens frequency"
section.

TIMING
======

Change options to produce a ROM binary file.
Enable -DSTATIC only for CPP pre-defined symbols.

Rebuild to produce FASTA.BIN.

Program size from the IDE dialog is: 3587 (ROM) + 534 (RAM) = 4121 bytes.
The two other sections correspond to page zero and initialization code.

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks fasta.bin -start ???? -end ???? -counter 999999999
(DID NOT TIME DUE TO ERRORS)

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C MSDOS V750
4121 bytes exact

Disqualified due to incorrect results.
