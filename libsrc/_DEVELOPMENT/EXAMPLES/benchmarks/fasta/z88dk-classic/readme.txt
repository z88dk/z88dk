CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

classic/sccz80/FAILS UNABLE TO COMPILE
zcc +zx -vn -DSTATIC -DPRINTF -O2 fasta.c -o fasta -lm -lndos -pragma-define:USING_amalloc -create-app

classic/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -compiler=sdcc --max-allocs-per-node200000 --fsigned-char fasta.c -o fasta -lmath48 -lmalloc -lndos -pragma-define:USING_amalloc -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80/FAILS UNABLE TO COMPILE
zcc +test -vn -DSTATIC -TIMER -D__Z88DK -O2 fasta.c -o fasta.bin -m -lm -lndos -pragma-define:USING_amalloc

classic/zsdcc
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc --max-allocs-per-node200000 --fsigned-char fasta.c -o fasta.bin -m -lmath48 -lmalloc -lndos -pragma-define:USING_amalloc

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks fasta.bin -start 0546 -end 05bc -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 18, 2017
zsdcc #9852 / classic
3519 bytes less page zero

cycle count  = 256212331
time @ 4MHz  = 256212331 / 4*10^6 = 64.05 sec
