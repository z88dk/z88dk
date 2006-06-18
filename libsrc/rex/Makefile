
include ../Make.config

all:
	cd graphics ; $(MAKE) ; cd ..

.c.o:
	zcc +rex $(CFLAGS) $*.c


clean:
	$(RM) *.o*  *~  zcc_opt.def
	cd graphics ; $(MAKE) clean ; cd ..
	cd farcall ; $(MAKE) clean ; cd ..
