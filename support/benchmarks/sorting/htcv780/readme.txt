CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

Using IDE HPDZ.EXE make a new project containing SORT.C.
Choose CP/M target and max optimizations with global optimization = 9.

Under "MAKE->CPP pre-defined symbols" add -DPRINTF -DSTYLE=0 -DNUM=20.
Build the program, ignoring warnings as they come up.

Run on a cpm emulator to verify results.

Repeat this for all combinations:

-DPRINTF -DSTYLE=0 -DNUM=20 (above)
-DPRINTF -DSTYLE=1 -DNUM=20
-DPRINTF -DSTYLE=2 -DNUM=20
-DPRINTF -DSTYLE=3 -DNUM=20

-DPRINTF -DSTYLE=0 -DNUM=5000
-DPRINTF -DSTYLE=1 -DNUM=5000
-DPRINTF -DSTYLE=2 -DNUM=5000
-DPRINTF -DSTYLE=3 -DNUM=5000

TIMING
======

Change options to produce a ROM binary file.

For each combination of:

-DPRINTF -DSTYLE=0 -DNUM=20
-DPRINTF -DSTYLE=1 -DNUM=20
-DPRINTF -DSTYLE=2 -DNUM=20
-DPRINTF -DSTYLE=3 -DNUM=20

-DPRINTF -DSTYLE=0 -DNUM=5000
-DPRINTF -DSTYLE=1 -DNUM=5000
-DPRINTF -DSTYLE=2 -DNUM=5000
-DPRINTF -DSTYLE=3 -DNUM=5000

Rebuild to produce SORT.BIN.


To determine start and stop timing points, the output binaries
were manually inspected.  TICKS command:

ticks sort.bin -start 0116 -end 0127 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

Program size is taken from the largest 20-number program (this corresponds
to -DPRINTF -DSTYLE=0 -DNUM=20, the random number sort).  From the IDE
dialog:  2382 (ROM) + 97 (RAM) = 2479 bytes.  The two other sections
correspond to page zero and initialization code.


RESULT
======

HITECH C MSDOS V750
2479 bytes exact

               cycle count    time @ 4MHz

sort-ran-20         230384     0.0576 sec
sort-ord-20         134515     0.0336 sec
sort-rev-20         163275     0.0408 sec
sort-equ-20         206389     0.0516 sec

sort-ran-5000    126858892    31.7147 sec
sort-ord-5000     72285966    18.0715 sec
sort-rev-5000     77909169    19.4773 sec
sort-equ-5000    136825609    34.2064 sec
