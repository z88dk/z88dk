
#CFLAGS = -compiler=sdcc

all: wc.com tail.com sort.com ddir.com adv_a.com enigma.com fib.com mm.com rpn.com tic.com sorter.com othello.com

wc.com: ../osca/wc.c
	zcc +cpm -vn $(CFLAGS) -DWILDCARD ../osca/wc.c -create-app -owc.bin

tail.com: ../osca/tail.c
	zcc +cpm -vn $(CFLAGS)  -lmalloc -DAMALLOC -O3 ../osca/tail.c -create-app -otail.bin

sort.com: ../osca/sort.c
	zcc +cpm -vn $(CFLAGS)  -lmalloc -DAMALLOC -O3 ../osca/sort.c -create-app -osort.bin

ddir.com: ../osca/ddir.c
	zcc +cpm -vn  $(CFLAGS) ../osca/ddir.c -O3 -create-app -oddir.bin

adv_a.com: ../console/adv_a.c
	zcc +cpm -vn $(CFLAGS) ../console/adv_a.c -I../console -create-app -DDISK -DCOMPUTE_SCORE -O3 -oadv_a.bin

enigma.com: ../console/enigma.c
	zcc +cpm -vn $(CFLAGS)  ../console/enigma.c -create-app -oenigma.bin

fib.com: ../console/fib.c
	zcc +cpm -vn $(CFLAGS)  ../console/fib.c -create-app -ofib.bin

mm.com: ../console/mm.c
	zcc +cpm -vn  $(CFLAGS) -create-app ../console/mm.c -omm.bin

rpn.com: ../console/rpn.c
	zcc +cpm -vn  $(CFLAGS) -create-app ../console/rpn.c -orpn.bin

tic.com: ../console/tic.c
	zcc +cpm -vn  $(CFLAGS) -create-app ../console/tic.c -otic.bin

sorter.com: ../console/sorter.c
	zcc +cpm -vn $(CFLAGS)  -create-app ../console/sorter.c -osorter.bin

othello.com: ../othello.c
	zcc +cpm -vn  $(CFLAGS) -O3 -create-app ../othello.c -I.. -oothello.bin

clean:
	$(RM) *.com *.i *.asm *.tap *.op* *.o *~ zcc_opt.def *.COM *.bin

