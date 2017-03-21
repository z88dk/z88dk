CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

VERIFY CORRECT RESULT
=====================

C -V -LF -DSTATIC -DPRINTF -O N-BODY.C

Run N-BODY.COM and verify correct printout.

** HTC CPM IS UNABLE TO COMPUTE THE CONSTANT EXPRESSIONS
USED TO INITIALIZE "struct planet bodies[]" SO UNABLE TO
COMPILE.  MAY COME BACK AND FILL IN HAND COMPUTED QUANTITIES.

TIMING
======

C -V -LF -DSTATIC -O -MN-BODY.MAP N-BODY.C

Program size can be determined from information in the
map file.

SIZE = text + data + bss = ? bytes

CP/M COM files begin at address 0x100.  To time with TICKS
this needs to be embedded into a binary that starts at
address 0.  Bytes leading up to 0x100 are zeroes, meaning NOP.

appmake +rom -s 32768 -f 0 -o nb0.bin
appmake +inject -b nb0.bin -i N-BODY.COM -s 256 -o nb.bin

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks nb.bin -start ???? -end ???? -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309
???? bytes less cpm overhead

cycle count  = ?
time @ 4MHz  = ? / 4*10^6 = ? sec
