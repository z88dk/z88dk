
all: rndsphere.tap clisp_speclisp.tap clisp.tap hawk.tap \
	adv_a.tap ansitest.tap enigma.tap fib.tap mm.tap rpn.tap tic.tap \
	sorter.tap snakes.tap dstar.tap dstar_native.tap microman.tap \
	othello.tap othello_udg.tap wall.tap gfx.tap save.tap ex10b.tap \
	ccoswave.tap c3d.tap cmandel.tap csprite.tap zxbasic.tap zxcurrah.tap \
	threading.tap globe.tap chessboard.tap mandel.tap julia.tap \
	smallgfx.tap stencil.tap clock.tap showlib3d.tap smallgfx2.tap \
	wintest.tap sinwave_fast.tap sinwave_small.tap coswave_fast.tap \
	coswave_small.tap spritest.tap smile.tap xample.tap psgtest.tap \
	ex12.tap clicktest.tap fx.tap sndtest.tap synthdemo.tap fontexample.tap


fontexample.tap: fontexample.c
	zcc +zx -vn -lndos fontexample.c -create-app -o fontexample.bin

clisp.tap: ../clisp/clisp.c
	zcc +zx -vn -lndos ../clisp/clisp.c -create-app -O3 -DLARGEMEM=1200 -oclisp.bin

clisp_speclisp.tap: ../clisp/clisp.c
	zcc +zx -vn -lndos ../clisp/clisp.c -create-app -O3 -DLARGEMEM=3000 -DGRAPHICS -llib3d -DSHORT -DSPECLISP -oclisp_speclisp.bin

adv_a.tap: ../console/adv_a.c
	zcc +zx -vn -lndos ../console/adv_a.c -I../console -create-app -DTAPE -DPICS -DCOMPUTE_SCORE -O3 -zorg=27000 -oadv_a.bin

ansitest.tap: ../console/ansitest.c
	zcc +zx -clib=ansi -vn -lndos ../console/ansitest.c -create-app -oansitest.bin

enigma.tap: ../console/enigma.c
	zcc +zx -vn -lndos ../console/enigma.c -create-app -oenigma.bin

fib.tap: ../console/fib.c
	zcc +zx -vn -lndos ../console/fib.c -create-app -ofib.bin

mm.tap: ../console/mm.c
	zcc +zx -vn -lndos -create-app ../console/mm.c -omm.bin

rpn.tap: ../console/rpn.c
	zcc +zx -vn -lndos -create-app ../console/rpn.c -orpn.bin

tic.tap: ../console/tic.c
	zcc +zx -vn -lndos -create-app ../console/tic.c -otic.bin 

sorter.tap: ../console/sorter.c
	zcc +zx -vn -lndos -create-app ../console/sorter.c -osorter.bin

snakes.tap: ../graphics/snakes.c
	zcc +zx -vn  -lndos ../graphics/snakes.c -I.. -DPSG -lm -DJOYSTICK_DIALOG -DSPEED=1500 -create-app -osnakes.bin

dstar.tap: ../dstar.c
	zcc +zx -vn  -lndos ../dstar.c -I.. -Dspritesize=16 -DSOUND -create-app -odstar.bin

dstar_native.tap: dstar.c
	zcc +zx -vn -lndos dstar.c -o dstar_native.bin -create-app

microman.tap: ../microman.c
	zcc +zx -vn -lndos -create-app -omicroman.bin -DSOUND -DJOYSTICK_DIALOG -I.. ../microman.c

othello.tap: ../othello.c
	zcc +zx -vn -lndos -O3 -create-app -zorg=50000 -DGRAPHICS ../othello.c -I.. -oothello.bin

othello_udg.tap: ../othello.c
	zcc +zx -vn -lndos -O3 -create-app -DREDEFINED_FONT ../othello.c -I.. -oothello_udg.bin

wall.tap: ../wall.c
	zcc +zx -vn -lndos -create-app -DJOYSTICK -DBANNERS -Dspritesize=8 -DSOUND -DCLOCK -O3 -I.. ../wall.c -owall.bin

save.tap: save.c
	zcc +zx -vn save.c -o save.bin -create-app -lndos

ex10b.tap: ex10b.c
	 zcc +zx -vn ex10b.c -o ex10b.bin -create-app  -lndos

gfx.tap: gfx.c
	zcc +zx -vn gfx.c -o gfx.bin -lndos -create-app -lm

ccoswave.tap: ccoswave.c
	zcc +zx -vn ccoswave.c -lndos -lm -create-app -occoswave.bin

c3d.tap: c3d.c
	zcc +zx -vn c3d.c -lndos -llib3d -create-app -oc3d.bin

cmandel.tap: cmandel.c
	zcc +zx -vn cmandel.c -lndos -lm -create-app -ocmandel.bin

csprite.tap: csprite.c
	zcc +zx -vn csprite.c -lndos -create-app -ocsprite.bin

zxbasic.tap: zxbasic.c
	zcc +zx -vn zxbasic.c -lndos -create-app -ozxbasic.bin -lm

zxcurrah.tap: zxcurrah.c
	zcc +zx -vn zxcurrah.c -lndos -create-app -ozxcurrah.bin -lm

threading.tap: preempt.c
	zcc +zx -vn preempt.c -lndos -create-app -othreading.bin -lpreempt

opusdump.tap: opusdump.c
	zcc +zx -vn opusdump.c -lndos -create-app -lrs232plus -oopusdump.bin

globe.tap: ../graphics/globe.c
	zcc +zx -vn -lndos -create-app -lm ../graphics/globe.c -oglobe.bin

chessboard.tap: ../graphics/chessboard.c
	zcc +zx -vn -I../graphics ../graphics/chessboard.c -lndos -lm -create-app -ochessboard.bin

hawk.tap: ../graphics/hawk.c
	zcc +zx -vn ../graphics/hawk.c -lndos -lm -create-app -DSOUND -ohawk.bin
	
mandel.tap: ../graphics/mandel.c
	zcc +zx -vn ../graphics/mandel.c -lndos -lm -create-app -omandel.bin

julia.tap: ../graphics/julia.c
	zcc +zx -vn ../graphics/julia.c -lndos -lm -create-app -ojulia.bin

smallgfx.tap: ../graphics/smallgfx.c
	zcc +zx -vn ../graphics/smallgfx.c -lndos -lm -create-app -osmallgfx.bin

rndsphere.tap: ../graphics/rndsphere.c
	zcc +zx -vn ../graphics/rndsphere.c -lndos -lm -create-app -orndsphere.bin

stencil.tap: ../graphics/stencil.c
	zcc +zx -vn ../graphics/stencil.c -lndos -lm -llib3d -create-app -ostencil.bin

clock.tap: ../graphics/clock.c
	zcc +zx -vn ../graphics/clock.c -I../graphics -lndos -lm -llib3d -DDETAILED -create-app -oclock.bin

showlib3d.tap: ../graphics/showlib3d.c
	zcc +zx -vn ../graphics/showlib3d.c -lndos -lm -llib3d -create-app -oshowlib3d.bin

smallgfx2.tap: ../graphics/smallgfx2.c
	zcc +zx -vn ../graphics/smallgfx2.c -lndos -lm -create-app -osmallgfx2.bin

wintest.tap: ../graphics/wintest.c
	zcc +zx -vn ../graphics/wintest.c -lndos -lm -create-app -owintest.bin

sinwave_fast.tap: ../graphics/sinwave.c
	zcc +zx -vn ../graphics/sinwave.c -lndos -lm  -create-app -osinwave_fast.bin

sinwave_small.tap: ../graphics/sinwave.c
	zcc +zx -vn ../graphics/sinwave.c -lndos -lmzx_tiny -O3 -create-app -osinwave_small.bin

coswave_fast.tap: ../graphics/coswave.c
	zcc +zx -vn ../graphics/coswave.c -lndos -lm  -create-app -ocoswave_fast.bin

coswave_small.tap: ../graphics/coswave.c
	zcc +zx -vn ../graphics/coswave.c -lndos -lmzx_tiny -O3 -create-app -ocoswave_small.bin

spritest.tap: ../graphics/spritest.c
	zcc +zx -vn ../graphics/spritest.c -lndos -create-app -ospritest.bin

smile.tap: ../ticalc/smile.c
	zcc +zx -vn ../ticalc/smile.c -lndos -create-app -osmile.bin

xample.tap: ../graphics/xample.c
	zcc +zx -vn ../graphics/xample.c -lndos -create-app -oxample.bin

clicktest.tap: ../sound/clicktest.c
	zcc +zx -vn ../sound/clicktest.c -lndos -create-app -oclicktest.bin

psgtest.tap: ../sound/psgtest.c
	zcc +zx -vn ../sound/psgtest.c -lndos -lm -create-app -DBEEPER -opsgtest.bin
	
ex12.tap: ../sound/ex12.c
	zcc +zx -vn ../sound/ex12.c -lndos -lm -create-app -oex12.bin

fx.tap: ../sound/fx.c
	zcc +zx -vn ../sound/fx.c -lndos -create-app -ofx.bin

sndtest.tap: ../sound/sndtest.c
	zcc +zx -vn ../sound/sndtest.c -lndos -lm -create-app -osndtest.bin

synthdemo.tap: ../sound/synthdemo.c
	zcc +zx -vn ../sound/synthdemo.c -lndos -create-app -osynthdemo.bin

clean:
	$(RM) *.bin *.i *.asm *.scr *.tap *.op* *.o *~ zcc_opt.def *.reloc

