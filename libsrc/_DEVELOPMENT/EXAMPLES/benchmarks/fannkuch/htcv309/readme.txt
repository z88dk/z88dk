CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

VERIFY CORRECT RESULT
=====================

C -V -DSTATIC -DPRINTF -O FANNKUCH.C

Run FANNKUCH.COM and verify correct printout.

TIMING
======

C -V -DSTATIC -O -MFANNKUCH.MAP FANNKUCH.C

Program size can be determined from information in the
map file.

SIZE = text + data + bss = 0x454 + 0x08 + 0x66 = 1218 bytes

CP/M COM files begin at address 0x100.  To time with TICKS
this needs to be embedded into a binary that starts at
address 0.  Bytes leading up to 0x100 are zeroes, meaning NOP.

appmake +rom -s 32768 -f 0 -o fk0.bin
appmake +inject -b fk0.bin -i FANNKUCH.COM -s 256 -o fk.bin

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks fk.bin -start 0384 -end 3a6 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309
1218 bytes less cpm overhead

cycle count  = 56667034
time @ 4MHz  = 56667034 / 4*10^6 = 14.17 sec
