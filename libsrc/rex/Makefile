

all:
	cd graphics ; $(MAKE) ; cd ..

.c.o:
	zcc +rex -vn -make-lib $*.c


clean:
	$(RM) *.o*  *~  zcc_opt.def
	cd graphics ; $(MAKE) clean ; cd ..
	cd farcall ; $(MAKE) clean ; cd ..
