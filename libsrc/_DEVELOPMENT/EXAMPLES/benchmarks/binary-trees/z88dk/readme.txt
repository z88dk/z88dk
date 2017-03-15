CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result, we compiled using all combinations
of compiler and c library for the zx target:

classic/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 binary-trees.c -o bt -lm -lndos -lmalloc -create-app -pragma-define:USING_amalloc

classic/sdcc (fail)
zcc +zx -vn -DSTATIC -DPRINTF -compiler=sdcc -SO3 --max-allocs-per-node200000 binary-trees.c -o bt -lmath48 -lndos -lmalloc -create-app -pragma-define:USING_amalloc

new/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -startup=5 -O2 -clib=new binary-trees.c -o bt -lm -create-app

new/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -startup=5 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 binary-trees.c -o bt -lm -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80
zcc +cpm -vn -DSTATIC -DTIMER -O2 binary-trees.c -o bt -lm -lndos -lmalloc -m -create-app -pragma-define:USING_amalloc
appmake +rom -s 32768 -f 0 -o bt0.bin
appmake +inject -b bt0.bin -i BT.COM -s 256 -o bt.bin

classic/sdcc (fail)
zcc +embedded -vn -DSTATIC -DTIMER -compiler=sdcc -SO3 --max-allocs-per-node200000 binary-trees.c -o bt -lmath48 -lndos -lmalloc -m -create-app -pragma-define:USING_amalloc

new/sccz80
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new binary-trees.c -o bt -lm -m -pragma-include:zpragma.inc -create-app

new/zsdcc
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 binary-trees.c -o bt -lm -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks bt.bin -start 08dc -end 0a50 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 2, 2017
ZSDCC #9833


classic/sccz80
3886 bytes less cpm overhead

cycle count  = 
time @ 4MHz  = 


new/zsdcc
2690 bytes less page zero

cycle count  = 6574818298
time @ 4MHz  = 6574818298 / 4*10^6 = 27 min 24 sec





new/sccz80
2807 bytes less page zero

cycle count  = 6769295803
time @ 4MHz  = 6769295803 / 4*10^6 = 28 min 12 sec
