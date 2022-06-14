CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

Compiled with C309-15 from https://github.com/agn453/HI-TECH-Z80-C

VERIFY CORRECT RESULT
=====================

CC -V -N -OF -DSTATIC -DPRINTF N-BODY.C -LF

Run N-BODY.COM and verify correct printout.

C309 CPM IS UNABLE TO COMPUTE THE CONSTANT EXPRESSIONS
USED TO INITIALIZE "struct planet bodies[]"
SO CONSTANT EXPRESSIONS ARE CALCULATED BY HAND

TIMING
======

CC -V -N -OF -DSTATIC -MN-BODY.MAP N-BODY.C -LF

Program size can be determined from information in the
map file.

TOTAL       Name         Link     Load   Length
            (abs)           0        0        0
            text            0        0     116C
            data         116C     116C      448
            bss          15B4     15B4       4D

SIZE = text + data + bss = 0x116C + 0x448 + 0x4D = 5633 bytes

TICKS command:

z88dk-ticks N-BODY.COM -c 999999999999

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-15
5633 bytes exact

cycle count  = 1594771948
time @ 4MHz  = 1594771948 / 4*10^6 = 6 min 38 sec
