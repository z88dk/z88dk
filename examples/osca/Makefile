

all: wc tail sort ddir ansitest adv_a enigma fib mm rpn tic sorter dstar othello wall

wc:
	zcc +osca -vn -lflosdos -DWILDCARD wc.c -create-app -owc.bin

tail:
	zcc +osca -vn -lflosxdos -lmalloc -DAMALLOC -O3 tail.c -create-app -otail.bin

sort:
	zcc +osca -vn -lflosxdos -lmalloc -DAMALLOC -O3 sort.c -create-app -osort.bin

ddir:
	zcc +osca -vn -lndos ddir.c -O3 -create-app -oddir.bin

ansitest:
	zcc +osca -clib=ansi -vn -lndos ../console/ansitest.c -create-app -oansitest.bin

adv_a:
	zcc +osca -vn -lflosdos ../console/adv_a.c -I../console -create-app -DDISK -DCOMPUTE_SCORE -O3 -oadva.bin

enigma:
	zcc +osca -vn -lndos ../console/enigma.c -create-app -oenigma.bin

fib:
	zcc +osca -vn -lndos ../console/fib.c -create-app -ofib.bin

mm:
	zcc +osca -vn -lndos -create-app ../console/mm.c -omm.bin

rpn:
	zcc +osca -vn -lndos -create-app ../console/rpn.c -orpn.bin

tic:
	zcc +osca -vn -lndos -create-app ../console/tic.c -otic.bin

sorter:
	zcc +osca -vn -lndos -create-app ../console/sorter.c -osorter.bin

dstar:
	zcc +osca -vn ../dstar.c -I.. -Dspritesize=16 -create-app -odstar.bin

othello:
	zcc +osca -vn -lndos -O3 -create-app ../othello.c -I.. -oothello.bin

wall:
	zcc +osca -vn -lndos -create-app -DJOYSTICK -DBANNERS -Dspritesize=8 -O3 -I.. ../wall.c -owall.bin

clean:
	$(RM) *.bin *.i *.asm *.tap *.op* *.o *~ zcc_opt.def

