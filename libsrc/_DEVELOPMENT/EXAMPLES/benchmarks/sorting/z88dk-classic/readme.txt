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

z88dk-ticks sort-ran-20.bin -start 0161 -end 0174 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

Program size is taken from the largest program for the 20-number case.
All programs are very close in size.

RESULT
======

Z88DK March 14, 2022
classic / sccz80 Version: 19388-38ebdf3b7-20220307
1743 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          82618     0.0207 sec
sort-ord-20          52586     0.0131 sec
sort-rev-20          74474     0.0186 sec
sort-equ-20          52586     0.0131 sec

sort-ran-5000     93581395    23.3953 sec
sort-ord-5000     41378393    10.3446 sec
sort-rev-5000     63352461    15.8381 sec
sort-equ-5000     41378393    10.3446 sec


Z88DK March 14, 2022
classic / zsdcc Build: 4.2.0 #13131
1711 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          76591     0.0191 sec
sort-ord-20          48639     0.0122 sec
sort-rev-20          69357     0.0173 sec
sort-equ-20          48639     0.0122 sec

sort-ran-5000     86069623    21.5174 sec
sort-ord-5000     37803151     9.4508 sec
sort-rev-5000     58230674    14.5577 sec
sort-equ-5000     37803151     9.4508 sec
