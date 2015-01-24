

all: dstar adv_a ansitest enigma fib mm rpn tic sorter othello

dstar:
	zcc +ace -vn -create-app dstar.c -odstar.bin

adv_a:
	zcc +ace -vn ../console/adv_a.c -I../console -create-app -DTAPE -DCOMPUTE_SCORE -O3 -oadva.bin

ansitest:
	zcc +ace -clib=ansi -vn  ../console/ansitest.c -create-app -oansitest.bin

enigma:
	zcc +ace -vn  ../console/enigma.c -create-app -oenigma.bin

fib:
	zcc +ace -vn  ../console/fib.c -create-app -ofib.bin

mm:
	zcc +ace -vn  -create-app ../console/mm.c -omm.bin

rpn:
	zcc +ace -vn  -create-app ../console/rpn.c -orpn.bin

tic:
	zcc +ace -vn  -create-app ../console/tic.c -otic.bin

sorter:
	zcc +ace -vn  -create-app ../console/sorter.c -osorter.bin

othello:
	zcc +ace -vn -O3 -create-app -DREDEFINED_FONT ../othello.c -I.. -oothello.bin

clean:
	$(RM) *.bin *.i *.asm *.tap *.op* *.o *~ zcc_opt.def

