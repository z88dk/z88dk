CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

Compiled with C309-15 from https://github.com/agn453/HI-TECH-Z80-C

VERIFY CORRECT RESULT
=====================

CC -V -N -OF -DSTATIC -DPRINTF BIN-TREE.C -LF

Run BIN-TREE.COM and verify correct printout.

TIMING
======

CC -V -N -OF -DSTATIC -MBIN-TREE.MAP BIN-TREE.C -LF

Program size can be determined from information in the
map file.

TOTAL       Name         Link     Load   Length
            (abs)           0        0        0
            text            0        0     1293
            data         1293     1293      3F8
            bss          168B     168B       32
                
SIZE = text + data + bss = 0x1293 + 0x3F8 + 0x32 = 5821 bytes

To determine timing, the output binary was uploaded and run as a CP/M file.

z88dk-ticks BIN-TREE.COM -counter 999999999

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-15
5,821 bytes exact

cycle count  = 298416076
time @ 4MHz  = 298416076 / 4x10^6 = 74.60 seconds
