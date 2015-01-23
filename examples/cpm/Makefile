

all: wc tail sort ddir adv_a enigma fib mm rpn tic sorter othello

wc:
	zcc +cpm -vn -DWILDCARD ../osca/wc.c -create-app -owc.bin

tail:
	zcc +cpm -vn  -lmalloc -DAMALLOC -O3 ../osca/tail.c -create-app -otail.bin

sort:
	zcc +cpm -vn  -lmalloc -DAMALLOC -O3 ../osca/sort.c -create-app -osort.bin

ddir:
	zcc +cpm -vn  ../osca/ddir.c -O3 -create-app -oddir.bin

adv_a:
	zcc +cpm -vn ../console/adv_a.c -I../console -create-app -DDISK -DCOMPUTE_SCORE -O3 -oadva.bin

enigma:
	zcc +cpm -vn  ../console/enigma.c -create-app -oenigma.bin

fib:
	zcc +cpm -vn  ../console/fib.c -create-app -ofib.bin

mm:
	zcc +cpm -vn  -create-app ../console/mm.c -omm.bin

rpn:
	zcc +cpm -vn  -create-app ../console/rpn.c -orpn.bin

tic:
	zcc +cpm -vn  -create-app ../console/tic.c -otic.bin

sorter:
	zcc +cpm -vn  -create-app ../console/sorter.c -osorter.bin

othello:
	zcc +cpm -vn  -O3 -create-app ../othello.c -I.. -oothello.bin

clean:
	$(RM) *.bin *.i *.asm *.tap *.op* *.o *~ zcc_opt.def

