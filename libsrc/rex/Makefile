

all:
	cd graphics ; $(MAKE)

.c.o:
	zcc +rex -vn -make-lib $*.c


clean:
	rm -f *.o*  *~  zcc_opt.def
	cd graphics ; $(MAKE) clean
	cd farcall ; $(MAKE) clean
