CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result, compile for the zx target
and run on a spectrum emulator.

classic/sccz80
zcc +zx -vn -DPRINTF -DSTYLE=0 -DNUM=20 -O2 sort.c -o sort-ran-20 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=1 -DNUM=20 -O2 sort.c -o sort-ord-20 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=2 -DNUM=20 -O2 sort.c -o sort-rev-20 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=3 -DNUM=20 -O2 sort.c -o sort-equ-20 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=0 -DNUM=5000 -O2 sort.c -o sort-ran-5000 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=1 -DNUM=5000 -O2 sort.c -o sort-ord-5000 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=2 -DNUM=5000 -O2 sort.c -o sort-rev-5000 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=3 -DNUM=5000 -O2 sort.c -o sort-equ-5000 -lndos -create-app

classic/zsdcc
zcc +zx -vn -DPRINTF -DSTYLE=0 -DNUM=20 -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-ran-20 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=1 -DNUM=20 -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-ord-20 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=2 -DNUM=20 -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-rev-20 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=3 -DNUM=20 -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-equ-20 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=0 -DNUM=5000 -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-ran-5000 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=1 -DNUM=5000 -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-ord-5000 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=2 -DNUM=5000 -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-rev-5000 -lndos -create-app
zcc +zx -vn -DPRINTF -DSTYLE=3 -DNUM=5000 -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-equ-5000 -lndos -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80
zcc +test -vn -DTIMER -DSTYLE=0 -DNUM=20 -D__Z88DK -O2 sort.c -o sort-ran-20.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=1 -DNUM=20 -D__Z88DK -O2 sort.c -o sort-ord-20.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=2 -DNUM=20 -D__Z88DK -O2 sort.c -o sort-rev-20.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=3 -DNUM=20 -D__Z88DK -O2 sort.c -o sort-equ-20.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=0 -DNUM=5000 -D__Z88DK -O2 sort.c -o sort-ran-5000.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=1 -DNUM=5000 -D__Z88DK -O2 sort.c -o sort-ord-5000.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=2 -DNUM=5000 -D__Z88DK -O2 sort.c -o sort-rev-5000.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=3 -DNUM=5000 -D__Z88DK -O2 sort.c -o sort-equ-5000.bin -lndos -m

classic/zsdcc
zcc +test -vn -DTIMER -DSTYLE=0 -DNUM=20 -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-ran-20.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=1 -DNUM=20 -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-ord-20.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=2 -DNUM=20 -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-rev-20.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=3 -DNUM=20 -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-equ-20.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=0 -DNUM=5000 -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-ran-5000.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=1 -DNUM=5000 -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-ord-5000.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=2 -DNUM=5000 -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-rev-5000.bin -lndos -m
zcc +test -vn -DTIMER -DSTYLE=3 -DNUM=5000 -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 sort.c -o sort-equ-5000.bin -lndos -m

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
On purpose these labels were placed so that their values would not vary
from compile to compile.  These address bounds were given to TICKS to
measure execution time.

A typical invocation of TICKS looked like this:

ticks sort-ran-20.bin -start 0161 -end 0174 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

Program size is taken from the largest program for the 20-number case.
All programs are very close in size.

RESULT
======

Z88DK March 25, 2017
classic / sccz80
1029 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          81544     0.0204 sec
sort-ord-20          53944     0.0135 sec
sort-rev-20          75472     0.0189 sec
sort-equ-20          53944     0.0135 sec

sort-ran-5000     80957310    20.2393 sec
sort-ord-5000     41381930    10.3455 sec
sort-rev-5000     63068198    15.7670 sec
sort-equ-5000     41381930    10.3455 sec


Z88DK March 25, 2017
classic / zsdcc #9852
995 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          77922     0.0195 sec
sort-ord-20          50242     0.0126 sec
sort-rev-20          70672     0.0177 sec
sort-equ-20          50242     0.0126 sec

sort-ran-5000     85903658    21.4759 sec
sort-ord-5000     38026708     9.5067 sec
sort-rev-5000     58261603    14.5654 sec
sort-equ-5000     38026708     9.5067 sec
