
all: adcvrt.rom rndsphere.rom clisp.rom today.rom \
	adva.rom ansitest.rom fib.rom mm.rom rpn.rom tic.rom \
	sorter.rom dstar.rom microman.rom othello.rom wall.rom \
	chessboard.rom mandel.rom julia.rom smallgfx.rom \
	stencil.rom clock.rom showlib3d.rom smallgfx2.rom \
	sinwave.rom coswave.rom spritest.rom 



adcvrt.rom: adcvrt.c
	zcc +cpm -subtype=px8 -create-app -oadcvrt adcvrt.c

rndsphere.rom: ../graphics/rndsphere.c
	zcc +cpm -subtype=px8 -vn ../graphics/rndsphere.c -lndos -lm -create-app -orndsphere

clisp.rom: ../clisp/clisp.c
	zcc +cpm -subtype=px8ansi -vn -lndos ../clisp/clisp.c -create-app -O3 -DLARGEMEM=1200 -DGRAPHICS -llib3d -oclisp

today.rom: ../console/today.c
	zcc +cpm -subtype=px8 -vn -lndos ../console/today.c -create-app -otoday

#hawk.rom: ../graphics/hawk.c
#	zcc +cpm -subtype=px8 -vn ../graphics/hawk.c -lndos -lm -create-app -DWIDE -ohawk
	
adva.rom: ../console/adv_a.c
	zcc +cpm -subtype=px8 -vn -lndos ../console/adv_a.c -I../console -create-app -DDISK -DCOMPUTE_SCORE -O3 -oadva

ansitest.rom: ../ticalc/ansitest.c
	zcc +cpm -subtype=px8ansi -vn -lndos ../ticalc/ansitest.c -create-app -oansitest

fib.rom: ../console/fib.c
	zcc +cpm -subtype=px8 -vn -lndos ../console/fib.c -create-app -ofib

mm.rom: ../console/mm.c
	zcc +cpm -subtype=px8 -vn -lndos -create-app ../console/mm.c -omm

rpn.rom: ../console/rpn.c
	zcc +cpm -subtype=px8 -vn -lndos -create-app ../console/rpn.c -orpn

tic.rom: ../console/tic.c
	zcc +cpm -subtype=px8 -vn -lndos -create-app ../console/tic.c -otic 

sorter.rom: ../console/sorter.c
	zcc +cpm -subtype=px8 -vn -lndos -create-app ../console/sorter.c -osorter

dstar.rom: ../dstar.c
	zcc +cpm -subtype=px8 -vn  -lndos ../dstar.c -I.. -Dspritesize=7 -create-app -odstar

microman.rom: ../microman.c
	zcc +cpm -subtype=px8 -vn -lndos -create-app -omicroman -DSIZE=6 -DCOMPACT=2 -I.. ../microman.c

othello.rom: ../othello.c
	zcc +cpm -subtype=px8 -vn -lndos -O3 -create-app -pragma-redirect=fputc_cons=putc4x6 -DSMALLGRAPHICS ../othello.c -I.. -oothello

wall.rom: ../wall.c
	zcc +cpm -subtype=px8 -vn -lndos -create-app -Dspritesize=3 -DCLOCK -O3 -I.. ../wall.c -owall

chessboard.rom: ../graphics/chessboard.c
	zcc +cpm -subtype=px8 -vn -I../graphics ../graphics/chessboard.c -D__G800__ -lndos -lm -create-app -ochessboard

mandel.rom: ../graphics/mandel.c
	zcc +cpm -subtype=px8 -vn ../graphics/mandel.c -lndos -lm -create-app -omandel

julia.rom: ../graphics/julia.c
	zcc +cpm -subtype=px8 -vn ../graphics/julia.c -lndos -lm -create-app -ojulia

smallgfx.rom: ../graphics/smallgfx.c
	zcc +cpm -subtype=px8 -vn ../graphics/smallgfx.c -lndos -lm -create-app -osmallgfx

stencil.rom: ../graphics/stencil.c
	zcc +cpm -subtype=px8 -vn ../graphics/stencil.c -lndos -lm -llib3d -create-app -ostencil

clock.rom: ../graphics/clock.c
	zcc +cpm -subtype=px8 -vn ../graphics/clock.c -I../graphics -lndos -lm -llib3d -create-app -oclock

showlib3d.rom: ../graphics/showlib3d.c
	zcc +cpm -subtype=px8 -vn ../graphics/showlib3d.c -lndos -lm -llib3d -create-app -oshowlib3d

smallgfx2.rom: ../graphics/smallgfx2.c
	zcc +cpm -subtype=px8 -vn ../graphics/smallgfx2.c -lndos -lm -create-app -osmallgfx2

sinwave.rom: ../graphics/sinwave.c
	zcc +cpm -subtype=px8 -vn ../graphics/sinwave.c -lndos -lm  -create-app -osinwave

coswave.rom: ../graphics/coswave.c
	zcc +cpm -subtype=px8 -vn ../graphics/coswave.c -lndos -lm  -create-app -ocoswave

spritest.rom: ../graphics/spritest.c
	zcc +cpm -subtype=px8 -vn ../graphics/spritest.c -lndos -create-app -ospritest

clean:
	$(RM) * *.i *.asm *.rom *.ROM *.op* *.o *~ zcc_opt.def *.reloc


