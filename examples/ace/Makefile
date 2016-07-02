

all: dstar.tap adv_a.tap ansitest.tap enigma.tap fib.tap mm.tap rpn.tap tic.tap sorter.tap othello.tap

dstar.tap: dstar.c dstar.h
	zcc +ace -vn -create-app dstar.c -odstar.bin

adv_a.tap: ../console/adv_a.c
	zcc +ace -vn ../console/adv_a.c -I../console -create-app -DTAPE -DCOMPUTE_SCORE -O3 -oadv_a.bin

ansitest.tap: ../console/ansitest.c
	zcc +ace -clib=ansi -vn  ../console/ansitest.c -create-app -oansitest.bin

enigma.tap: ../console/enigma.c
	zcc +ace -vn  ../console/enigma.c -create-app -oenigma.bin

fib.tap: ../console/fib.c
	zcc +ace -vn  ../console/fib.c -create-app -ofib.bin

mm.tap: ../console/mm.c
	zcc +ace -vn  -create-app ../console/mm.c -omm.bin

rpn.tap: ../console/rpn.c
	zcc +ace -vn  -create-app ../console/rpn.c -orpn.bin

tic.tap: ../console/tic.c
	zcc +ace -vn  -create-app ../console/tic.c -otic.bin

sorter.tap: ../console/sorter.c
	zcc +ace -vn  -create-app ../console/sorter.c -osorter.bin

othello.tap: ../othello.c
	zcc +ace -vn -O3 -create-app -DREDEFINED_FONT ../othello.c -I.. -oothello.bin

clean:
	$(RM) *.bin *.i *.asm *.tap *.op* *.o *~ zcc_opt.def *.reloc

