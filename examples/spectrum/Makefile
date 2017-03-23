

all: clisp adv_a ansitest enigma fib mm rpn tic sorter snakes dstar dstar_native microman othello othello_udg wall gfx save ex10b ccoswave c3d cmandel csprite zxbasic zxcurrah threading globe chessboard mandel julia smallgfx stencil clock showlib3d smallgfx2 wintest sinwave_fast sinwave_small coswave_fast coswave_small spritest smile xample psgtest ex10b ex12 clicktest fx sndtest synthdemo


clisp:
	zcc +zx -vn -lndos ../clisp/clisp.c -create-app -O3 -DLARGEMEM=1200 -oclisp.bin

adv_a:
	zcc +zx -vn -lndos ../console/adv_a.c -I../console -create-app -DTAPE -DPICS -DCOMPUTE_SCORE -O3 -zorg=27000 -oadv_a.bin

ansitest:
	zcc +zx -clib=ansi -vn -lndos ../console/ansitest.c -create-app -oansitest.bin

enigma:
	zcc +zx -vn -lndos ../console/enigma.c -create-app -oenigma.bin

fib:
	zcc +zx -vn -lndos ../console/fib.c -create-app -ofib.bin

mm:
	zcc +zx -vn -lndos -create-app ../console/mm.c -omm.bin

rpn:
	zcc +zx -vn -lndos -create-app ../console/rpn.c -orpn.bin

tic:
	zcc +zx -vn -lndos -create-app ../console/tic.c -otic.bin 

sorter:
	zcc +zx -vn -lndos -create-app ../console/sorter.c -osorter.bin

snakes:
	zcc +zx -vn  -lndos ../graphics/snakes.c -I.. -DPSG -lm -DJOYSTICK_DIALOG -DSPEED=1500 -create-app -osnakes.bin

dstar:
	zcc +zx -vn  -lndos ../dstar.c -I.. -Dspritesize=16 -DSOUND -create-app -odstar.bin

dstar_native:
	zcc +zx -vn -lndos dstar.c -o dstar_native.bin -create-app

microman:
	zcc +zx -vn -lndos -create-app -omicroman.bin -DSOUND -DJOYSTICK_DIALOG -I.. ../microman.c

othello:
	zcc +zx -vn -lndos -O3 -create-app -zorg=50000 -DGRAPHICS ../othello.c -I.. -oothello.bin

othello_udg:
	zcc +zx -vn -lndos -O3 -create-app -DREDEFINED_FONT ../othello.c -I.. -oothello_udg.bin

wall:
	zcc +zx -vn -lndos -create-app -DJOYSTICK -DBANNERS -Dspritesize=8 -DSOUND -DCLOCK -O3 -I.. ../wall.c -owall.bin

save:
	zcc +zx -vn save.c -o save.bin -create-app -lndos

ex10b:
	 zcc +zx -vn ex10b.c -o ex10b.bin -create-app  -lndos

gfx:
	zcc +zx -vn gfx.c -o gfx.bin -lndos -create-app -lm

ccoswave:
	zcc +zx -vn ccoswave.c -lndos -lm -create-app -occoswave.bin

c3d:
	zcc +zx -vn c3d.c -lndos -llib3d -create-app -oc3d.bin

cmandel:
	zcc +zx -vn cmandel.c -lndos -lm -create-app -ocmandel.bin

csprite:
	zcc +zx -vn csprite.c -lndos -create-app -ocsprite.bin

zxbasic:
	zcc +zx -vn zxbasic.c -lndos -create-app -ozxbasic.bin -lm

zxcurrah:
	zcc +zx -vn zxcurrah.c -lndos -create-app -ozxcurrah.bin -lm

threading:
	zcc +zx -vn preempt.c -lim2 -lndos -create-app -othreading.bin -lpreempt

opusdump:
	zcc +zx -vn opusdump.c -lndos -create-app -lrs232plus -oopusdump.bin

globe:
	zcc +zx -vn -lndos -create-app -lm ../graphics/globe.c -oglobe.bin

chessboard:
	zcc +zx -vn -I../graphics ../graphics/chessboard.c -lndos -lm -create-app -ochessboard.bin

mandel:
	zcc +zx -vn ../graphics/mandel.c -lndos -lm -create-app -omandel.bin

julia:
	zcc +zx -vn ../graphics/julia.c -lndos -lm -create-app -ojulia.bin

smallgfx:
	zcc +zx -vn ../graphics/smallgfx.c -lndos -lm -create-app -osmallgfx.bin

stencil:
	zcc +zx -vn ../graphics/stencil.c -lndos -lm -llib3d -create-app -ostencil.bin

clock:
	zcc +zx -vn ../graphics/clock.c -I../graphics -lndos -lm -llib3d -DDETAILED -create-app -oclock.bin

showlib3d:
	zcc +zx -vn ../graphics/showlib3d.c -lndos -lm -llib3d -create-app -oshowlib3d.bin

smallgfx2:
	zcc +zx -vn ../graphics/smallgfx2.c -lndos -lm -create-app -osmallgfx2.bin

wintest:
	zcc +zx -vn ../graphics/wintest.c -lndos -lm -lx11 -lmalloc -create-app -owintest.bin

sinwave_fast:
	zcc +zx -vn ../graphics/sinwave.c -lndos -lm -lmalloc -create-app -osinwave_fast.bin

sinwave_small:
	zcc +zx -vn ../graphics/sinwave.c -lndos -lmzx_tiny -O3 -create-app -osinwave_small.bin

coswave_fast:
	zcc +zx -vn ../graphics/coswave.c -lndos -lm -lmalloc -create-app -ocoswave_fast.bin

coswave_small:
	zcc +zx -vn ../graphics/coswave.c -lndos -lmzx_tiny -O3 -create-app -ocoswave_small.bin

spritest:
	zcc +zx -vn ../graphics/spritest.c -lndos -create-app -ospritest.bin

smile:
	zcc +zx -vn ../ticalc/smile.c -lndos -create-app -osmile.bin

xample:
	zcc +zx -vn ../graphics/xample.c -lndos -create-app -lx11 -oxample.bin

clicktest:
	zcc +zx -vn ../sound/clicktest.c -lndos -create-app -oclicktest.bin

psgtest:
	zcc +zx -vn ../sound/psgtest.c -lndos -lm -create-app -DBEEPER -opsgtest.bin
	
ex12:
	zcc +zx -vn ../sound/ex12.c -lndos -lm -create-app -oex12.bin

fx:
	zcc +zx -vn ../sound/fx.c -lndos -create-app -ofx.bin

sndtest:
	zcc +zx -vn ../sound/sndtest.c -lndos -lm -create-app -osndtest.bin

synthdemo:
	zcc +zx -vn ../sound/synthdemo.c -lndos -create-app -osynthdemo.bin

clean:
	$(RM) *.bin *.i *.asm *.tap *.op* *.o *~ zcc_opt.def *.reloc

