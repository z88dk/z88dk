CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

Compiled with C309-15 from https://github.com/agn453/HI-TECH-Z80-C

VERIFY CORRECT RESULT
=====================

CC -V -N -OF -DSTATIC -DPRINTF FANNKUCH.C

Run FANNKUCH.COM and verify correct printout.

TIMING
======

CC -V -N -OF -DSTATIC -MFANNKUCH.MAP FANNKUCH.C

Program size can be determined from information in the
map file.

TOTAL       Name         Link     Load   Length
        (abs)           0        0        0
        text            0        0      705
        data          705      705      366
        bss           A6B      A6B       68
                
SIZE = text + data + bss = 0x705 + 0x366 + 0x68 = 2771 bytes

To determine timing, the output binary was uploaded and run as a CP/M file.

z88dk-ticks FANNKUCH.COM -counter 999999999

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-15
2771 bytes exact

cycle count  = 56614856
time @ 4MHz  = 56614856 / 4*10^6 = 14.1537 sec
