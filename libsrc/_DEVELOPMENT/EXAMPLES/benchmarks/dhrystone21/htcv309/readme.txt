CHANGES TO SOURCE CODE
======================

ALL FILES

All C preprocessor commands like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

DHRY.H

The Z88DK pragmas had to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

After "include <math.h>" add:

typedef float float_t;
typedef float double_t;

VERIFY CORRECT RESULT
=====================

C -V -DSTATIC -DPRINTF -O DHRY_1.C DHRY_2.C

Rename output from DHRY_1.COM to DHRY.COM
(CP/M has difficulty with underscores in filenames).

Run DHRY.COM and verify correct printout.

TIMING
======

C -V -DSTATIC -O -MDHRY.MAP DHRY_1.C DHRY_2.C

Program size can be determined from information in the
map file.

SIZE = text + data + bss = 0x84c + 0x80 + 0x1463 = 7471 bytes

CP/M COM files begin at address 0x100.  To time with TICKS
this needs to be embedded into a binary that starts at
address 0.  Bytes leading up to 0x100 are zeroes, meaning NOP.

appmake +rom -s 32768 -f 0 -o dhry0.bin
appmake +inject -b dhry0.bin -i DHRY.COM -s 256 -o dhry.bin

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks dhry.bin -start 019c -end 0136 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309
7471 bytes less cpm overhead

cycle count  = 354120220
time @ 4MHz  = 354120220 / 4*10^6 = 88.53 sec
dhrystones/s = 20000 / 88.53 = 225.9120
DMIPS        = 225.9120 / 1757 = 0.12858
