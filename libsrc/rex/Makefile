

all:
	cd graphics ; make

.c.o:
	zcc +rex -vn -make-lib $*.c


clean:
	rm -f *.o*  *~  zcc_opt.def
	cd graphics ; make clean
	cd farcall ; make clean
