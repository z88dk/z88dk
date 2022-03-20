CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

Compiled with C309-12 from https://github.com/agn453/HI-TECH-Z80-C

VERIFY CORRECT RESULT
=====================

C -V -LF -DSTATIC -DPRINTF -O N-BODY.C

Run N-BODY.COM and verify correct printout.

C309 CPM IS UNABLE TO COMPUTE THE CONSTANT EXPRESSIONS
USED TO INITIALIZE "struct planet bodies[]"
SO CONSTANT EXPRESSIONS ARE CALCULATED BY HAND

TIMING
======

C -V -LF -DSTATIC -O -MN-BODY.MAP N-BODY.C

Program size can be determined from information in the
map file.

SIZE = text + data + bss = 16492 bytes

TOTAL		Name         Link     Load   Length
		(abs)           0        0        0
		text            0        0     381D
		data         381D     381D      5E4
		bss          3E01     3E01      26B

TICKS command:

z88dk-ticks N-BODY.COM -c 999999999999

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-12
16492 bytes less cpm overhead

cycle count  = 1593755080
time @ 4MHz  = 1593755080 / 4*10^6 = 6 min 38 sec
