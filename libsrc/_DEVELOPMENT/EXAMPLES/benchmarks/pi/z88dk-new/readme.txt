CHANGES TO SOURCE CODE
======================

None.

The new c library supports a fast integer implementation and a
small integer implementation.  Both zsdcc and sccz80 can be
used in combination with the new c library.

The default library is built with the small math implementation.


VERIFY CORRECT RESULT
=====================

To verify correct result, we compiled for the zx spectrum target
all combinations above:

1. NEW LIBRARY WITH SMALL INTEGER MATH

new/sccz80/small
zcc +zx -vn -clib=new -O2 -DSTATIC -DTIMER -DPRINTF pi.c -o pi -create-app
zcc +zx -vn -clib=new -O2 -DSTATIC -DTIMER -DPRINTF pi_ldiv.c -o pi_ldiv -create-app

new/zsdcc/small
zcc +zx -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -DPRINTF pi.c -o pi -create-app
zcc +zx -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -DPRINTF pi_ldiv.c -o pi_ldiv -create-app

2. NEW LIBRARY WITH FAST INTEGER MATH

Configure the zx library by editing:
z88dk/libsrc/_DEVELOPMENT/target/zx/config_clib.m4

Change "define(`__CLIB_OPT_IMATH', 0)" to "define(`__CLIB_OPT_IMATH', 75)"
From z88dk/libsrc/_DEVELOPMENT run "Winmake zx" (windows) or "make TARGET=zx" (other).

new/sccz80/fast
zcc +zx -vn -clib=new -O2 -DSTATIC -DTIMER -DPRINTF pi.c -o pi -create-app
zcc +zx -vn -clib=new -O2 -DSTATIC -DTIMER -DPRINTF pi_ldiv.c -o pi_ldiv -create-app

new/zsdcc/fast
zcc +zx -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -DPRINTF pi.c -o pi -create-app
zcc +zx -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -DPRINTF pi_ldiv.c -o pi_ldiv -create-app

4. RESTORE NEW LIBRARY CONFIGURATION

Undo changes in 3 and rebuild the zx library.


(These compile settings were found to give the best result).

The output was run in a spectrum emulator and results were verified.

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

1. NEW LIBRARY WITH SMALL INTEGER MATH

new/sccz80/small
zcc +z80 -vn -startup=0 -clib=new -O2 -DSTATIC -DTIMER pi.c -o pi -m -pragma-include:zpragma.inc -create-app
zcc +z80 -vn -startup=0 -clib=new -O2 -DSTATIC -DTIMER pi_ldiv.c -o pi_ldiv -m -pragma-include:zpragma.inc -create-app

new/zsdcc/small
zcc +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER pi.c -o pi -m -pragma-include:zpragma.inc -create-app
zcc +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER pi_ldiv.c -o pi_ldiv -m -pragma-include:zpragma.inc -create-app

2. NEW LIBRARY WITH FAST INTEGER MATH

Configure the z80 library by editing:
z88dk/libsrc/_DEVELOPMENT/target/z80/config_clib.m4

Change "define(`__CLIB_OPT_IMATH', 0)" to "define(`__CLIB_OPT_IMATH', 75)"
From z88dk/libsrc/_DEVELOPMENT run "Winmake z80" (windows) or "make TARGET=z80" (other).

new/sccz80/fast
zcc +z80 -vn -startup=0 -clib=new -O2 -DSTATIC -DTIMER pi.c -o pi -m -pragma-include:zpragma.inc -create-app
zcc +z80 -vn -startup=0 -clib=new -O2 -DSTATIC -DTIMER pi_ldiv.c -o pi_ldiv -m -pragma-include:zpragma.inc -create-app

new/zsdcc/fast
zcc +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER pi.c -o pi -m -pragma-include:zpragma.inc -create-app
zcc +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER pi_ldiv.c -o pi_ldiv -m -pragma-include:zpragma.inc -create-app

4. RESTORE NEW LIBRARY CONFIGURATION

Undo changes in 3 and rebuild the z80 library.


In each case, the map file was used to look up symbols "TIMER_START"
and "TIMER_STOP".  These address bounds were given to TICKS to measure
execution time.

A typical invocation of TICKS looked like this:

ticks pi.bin -start 01a8 -end 0318 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 2, 2017
ZSDCC #9833

Z88DK April 4, 2020
ZSDCC #11556
PR #1436 demotion of small uint32*uint32 where multipliers are uint16*uint16


PI.C

new/sccz80/small (6269 bytes less page zero)

cycle count  = 5246791210 (March 2, 2017)
cycle count  = 4012440735 (April 4, 2020)
time @ 4MHz  = 4012440735 / 4*10^6 = 17 min 43 sec

new/zsdcc/small (6246 bytes less page zero)

cycle count  = 5278798872 (March 2, 2017, ZSDCC #9833)
cycle count  = 4067517071 (April 4, 2020,  ZSDCC #11556)
time @ 4MHz  = 4067517071 / 4*10^6 = 16 min 57 sec

new/sccz80/fast (8999 bytes less page zero)

cycle count  = 1708903088 (March 2, 2017)
cycle count  = 1696878309 (April 4, 2020)
time @ 4MHz  = 1696878309 / 4*10^6 = 7 min 04 sec

new/zsdcc/fast (8997 bytes less page zero)

cycle count  = 1739403552 (March 2, 2017, ZSDCC #9833)
cycle count  = 1756864232 (April 4, 2020, ZSDCC #11556)
time @ 4MHz  = 1756864232 / 4*10^6 = 7 min 19 sec


PI_LDIV.C

new/sccz80/small (6382 bytes less page zero)

cycle count  = 3810732458 (March 2, 2017)
cycle count  = 2576381983 (April 4, 2020)
time @ 4MHz  = 2576381983 / 4*10^6 = 10 min 44 sec

new/zsdcc/small (6348 bytes less page zero)

cycle count  = 3827247920 (March 2, 2017, ZSDCC #9833) 
cycle count  = 2609489119 (April 4, 2020, ZSDCC #11556)
time @ 4MHz  = 2609489119 / 4*10^6 = 10 min 52 sec

new/sccz80/fast (9131 bytes less page zero)

cycle count  = 1313857712 (March 2, 2017)
cycle count  = 1301832933 (April 4, 2020)
time @ 4MHz  = 1301832933 / 4*10^6 = 5 min 25 sec

new/zsdcc/fast (9097 bytes less page zero)

cycle count  = 1328865976 (March 2, 2017, ZSDCC #9833)
cycle count  = 1339849656 (April 4, 2020, ZSDCC #11556)
time @ 4MHz  = 1339849656 / 4*10^6 = 5 min 35 sec
