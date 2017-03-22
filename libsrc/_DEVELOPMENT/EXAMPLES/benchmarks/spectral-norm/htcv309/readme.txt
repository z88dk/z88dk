CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

Eliminate all instances of 'const'.

VERIFY CORRECT RESULT
=====================

C -V -LF -DSTATIC -DPRINTF -O SPECTRAL.C

Run SPECTRAL.COM and verify correct printout.

error: 1 * 10^(-6)

TIMING
======

C -V -LF -DSTATIC -O -MSPECTRAL.MAP SPECTRAL.C

Program size can be determined from information in the
map file.

SIZE = text + data + bss = 0x9cb + 0x32 + 0x4c5 = 3778 bytes

CP/M COM files begin at address 0x100.  To time with TICKS
this needs to be embedded into a binary that starts at
address 0.  Bytes leading up to 0x100 are zeroes, meaning NOP.

appmake +rom -s 32768 -f 0 -o sp0.bin
appmake +inject -b sp0.bin -i SPECTRAL.COM -s 256 -o sp.bin

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks sp.bin -start 02bf -end 03d1 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309
3778 bytes less cpm overhead

error: 1 * 10^(-6)

cycle count  = 6798318787
time @ 4MHz  = 6798318787 / 4*10^6 = 28 min 20 sec
