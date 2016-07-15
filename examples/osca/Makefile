

all: wc.exe tail.exe sort.exe ddir.exe ansitest.exe adv_a.exe enigma.exe fib.exe mm.exe rpn.exe tic.exe sorter.exe dstar.exe othello.exe wall.exe

wc.exe: wc.c
	zcc +osca -vn -lflosdos -DWILDCARD wc.c -create-app -owc.bin

tail.exe: tail.c
	zcc +osca -vn -lflosxdos -lmalloc -DAMALLOC -O3 tail.c -create-app -otail.bin

sort.exe: sort.c
	zcc +osca -vn -lflosxdos -lmalloc -DAMALLOC -O3 sort.c -create-app -osort.bin

ddir.exe: ddir.c
	zcc +osca -vn -lndos ddir.c -O3 -create-app -oddir.bin

ansitest.exe: ../console/ansitest.c
	zcc +osca -clib=ansi -vn -lndos ../console/ansitest.c -create-app -oansitest.bin

adv_a.exe: ../console/adv_a.c
	zcc +osca -vn -lflosdos ../console/adv_a.c -I../console -create-app -DDISK -DCOMPUTE_SCORE -O3 -oadv_a.bin

enigma.exe: ../console/enigma.c
	zcc +osca -vn -lndos ../console/enigma.c -create-app -oenigma.bin

fib.exe: ../console/fib.c
	zcc +osca -vn -lndos ../console/fib.c -create-app -ofib.bin

mm.exe: ../console/mm.c
	zcc +osca -vn -lndos -create-app ../console/mm.c -omm.bin

rpn.exe: ../console/rpn.c
	zcc +osca -vn -lndos -create-app ../console/rpn.c -orpn.bin

tic.exe: ../console/tic.c
	zcc +osca -vn -lndos -create-app ../console/tic.c -otic.bin

sorter.exe: ../console/sorter.c
	zcc +osca -vn -lndos -create-app ../console/sorter.c -osorter.bin

dstar.exe: ../dstar.c ../dstar.h
	zcc +osca -vn ../dstar.c -I.. -Dspritesize=16 -create-app -odstar.bin -lndos

othello.exe: ../othello.c
	zcc +osca -vn -lndos -O3 -create-app ../othello.c -I.. -oothello.bin

wall.exe: ../wall.c
	zcc +osca -vn -lndos -create-app -DJOYSTICK -DBANNERS -Dspritesize=8 -O3 -I.. ../wall.c -owall.bin

clean:
	$(RM) *.bin *.i *.asm *.tap *.op* *.o *~ zcc_opt.def *.exe

