CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

Eliminate all instances of 'const'.

Compiled with C309-15 from https://github.com/agn453/HI-TECH-Z80-C

VERIFY CORRECT RESULT
=====================

CC -V -N -OF -DSTATIC -DPRINTF SPECTRAL.C -LF

Run SPECTRAL.COM and verify correct printout.

error: 1 * 10^(-6)

TIMING
======

CC -V -N -OF -DSTATIC -MSPECTRAL.MAP SPECTRAL.C -LF

Program size can be determined from information in the
map file.

TOTAL       Name         Link     Load   Length
            (abs)           0        0        0
            text            0        0      C98
            data          C98      C98      390
            bss          1028     1028      4C7

SIZE = text + data + bss = 0xC98 + 0x390 + 0x4C7 = 2135 bytes

z88dk-ticks SPECTRAL.COM -counter 999999999999

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-15
2135 bytes exact

error: 1 * 10^(-6)

cycle count  = 6790499956
time @ 4MHz  = 6790499956 / 4*10^6 = 28 min 18 sec
