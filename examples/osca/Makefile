

all: WC.EXE TAIL.EXE SORT.EXE DDIR.EXE ANSITEST.EXE ADV_A.EXE ENIGMA.EXE FIB.EXE MM.EXE RPN.EXE TIC.EXE SORTER.EXE DSTAR.EXE OTHELLO.EXE WALL.EXE

WC.EXE: wc.c
	zcc +osca -vn -lflosdos -DWILDCARD wc.c -create-app -owc.bin

TAIL.EXE: tail.c
	zcc +osca -vn -lflosxdos -lmalloc -DAMALLOC -O3 tail.c -create-app -otail.bin

SORT.EXE: sort.c
	zcc +osca -vn -lflosxdos -lmalloc -DAMALLOC -O3 sort.c -create-app -osort.bin

DDIR.EXE: ddir.c
	zcc +osca -vn -lndos ddir.c -O3 -create-app -oddir.bin

ANSITEST.EXE: ../console/ansitest.c
	zcc +osca -clib=ansi -vn -lndos ../console/ansitest.c -create-app -oansitest.bin

ADV_A.EXE: ../console/adv_a.c
	zcc +osca -vn -lflosdos ../console/adv_a.c -I../console -create-app -DDISK -DCOMPUTE_SCORE -O3 -oadv_a.bin

ENIGMA.EXE: ../console/enigma.c
	zcc +osca -vn -lndos ../console/enigma.c -create-app -oenigma.bin

FIB.EXE: ../console/fib.c
	zcc +osca -vn -lndos ../console/fib.c -create-app -ofib.bin

MM.EXE: ../console/mm.c
	zcc +osca -vn -lndos -create-app ../console/mm.c -omm.bin

RPN.EXE: ../console/rpn.c
	zcc +osca -vn -lndos -create-app ../console/rpn.c -orpn.bin

TIC.EXE: ../console/tic.c
	zcc +osca -vn -lndos -create-app ../console/tic.c -otic.bin

SORTER.EXE: ../console/sorter.c
	zcc +osca -vn -lndos -create-app ../console/sorter.c -osorter.bin

DSTAR.EXE: ../dstar.c ../dstar.h
	zcc +osca -vn ../dstar.c -I.. -Dspritesize=16 -create-app -odstar.bin -lndos

OTHELLO.EXE: ../othello.c
	zcc +osca -vn -lndos -O3 -create-app ../othello.c -I.. -oothello.bin

WALL.EXE: ../wall.c
	zcc +osca -vn -lndos -create-app -DJOYSTICK -DBANNERS -Dspritesize=8 -O3 -I.. ../wall.c -owall.bin

clean:
	$(RM) *.bin *.i *.asm *.tap *.op* *.o *~ zcc_opt.def *.EXE

