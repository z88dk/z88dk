
#CFLAGS = -compiler=sdcc -O3

all: dpb.com othello.com adv_a.com enigma.com fib.com mm.com rpn.com sorter.com tic.com ddir.com sort.com tail.com wc.com

dpb.com: dpb.c
	zcc +cpm -vn $(CFLAGS) -create-app dpb.c -odpb.bin

othello.com: ../othello.c
	zcc +cpm -vn $(CFLAGS) -I.. -create-app ../othello.c -oothello.bin

adv_a.com: ../console/adv_a.c
	zcc +cpm -vn $(CFLAGS) -DDISK -DCOMPUTE_SCORE -I../console -create-app ../console/adv_a.c -oadv_a.bin

enigma.com: ../console/enigma.c
	zcc +cpm -vn $(CFLAGS) -create-app ../console/enigma.c -oenigma.bin

fib.com: ../console/fib.c
	zcc +cpm -vn $(CFLAGS) -create-app ../console/fib.c -ofib.bin

mm.com: ../console/mm.c
	zcc +cpm -vn $(CFLAGS) -create-app ../console/mm.c -omm.bin

rpn.com: ../console/rpn.c
	zcc +cpm -vn $(CFLAGS) -create-app ../console/rpn.c -orpn.bin

sorter.com: ../console/sorter.c
	zcc +cpm -vn $(CFLAGS) -create-app ../console/sorter.c -osorter.bin

tic.com: ../console/tic.c
	zcc +cpm -vn $(CFLAGS) -create-app ../console/tic.c -otic.bin

ddir.com: ../osca/ddir.c
	zcc +cpm -vn $(CFLAGS) -create-app ../osca/ddir.c -oddir.bin

sort.com: ../osca/sort.c
	zcc +cpm -vn $(CFLAGS) -DAMALLOC -create-app ../osca/sort.c -osort.bin

tail.com: ../osca/tail.c
	zcc +cpm -vn $(CFLAGS) -DAMALLOC -create-app ../osca/tail.c -otail.bin

wc.com: ../osca/wc.c
	zcc +cpm -vn $(CFLAGS) -DWILDCARD -create-app ../osca/wc.c -owc.bin


clean:
	$(RM) *.com *.i *.asm *.tap *.op* *.o *~ zcc_opt.def *.COM *.bin *.map *.lis *.def

