CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

VERIFY CORRECT RESULT
=====================

C -V -DPRINTF -DSTYLE=0 -DNUM=20 -O SORT.C
C -V -DPRINTF -DSTYLE=1 -DNUM=20 -O SORT.C
C -V -DPRINTF -DSTYLE=2 -DNUM=20 -O SORT.C
C -V -DPRINTF -DSTYLE=3 -DNUM=20 -O SORT.C

C -V -DPRINTF -DSTYLE=0 -DNUM=5000 -O SORT.C
C -V -DPRINTF -DSTYLE=1 -DNUM=5000 -O SORT.C
C -V -DPRINTF -DSTYLE=2 -DNUM=5000 -O SORT.C
C -V -DPRINTF -DSTYLE=3 -DNUM=5000 -O SORT.C

Run all the SORT.COMs and verify correct printout.

TIMING
======

C -V -DSTYLE=0 -DNUM=20 -O -MSORT.MAP SORT.C
C -V -DSTYLE=1 -DNUM=20 -O -MSORT.MAP SORT.C
C -V -DSTYLE=2 -DNUM=20 -O -MSORT.MAP SORT.C
C -V -DSTYLE=3 -DNUM=20 -O -MSORT.MAP SORT.C

C -V -DSTYLE=0 -DNUM=5000 -O -MSORT.MAP SORT.C
C -V -DSTYLE=1 -DNUM=5000 -O -MSORT.MAP SORT.C
C -V -DSTYLE=2 -DNUM=5000 -O -MSORT.MAP SORT.C
C -V -DSTYLE=3 -DNUM=5000 -O -MSORT.MAP SORT.C

Program size is taken from the largest NUM=20
program and can be determined from information in the
map file.

SIZE = text + data + bss = 0xf7b + 0x9a + 0x30 = 4165 bytes

CP/M COM files begin at address 0x100.  To time with TICKS
this needs to be embedded into a binary that starts at
address 0.  Bytes leading up to 0x100 are zeroes, meaning NOP.

appmake +rom -s 32768 -f 0 -o s0.bin
appmake +inject -b s0.bin -i SORT.COM -s 256 -o sort.bin

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks sort.bin -start ???? -end ???? -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309
Unable to compile
