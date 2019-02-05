
include ../../Make.config

all:
	$(MAKE) -C graphics

.c.o:
	$(ZCC) +rex $(CFLAGS) $*.c


clean:
	$(RM) *.o*  *~  zcc_opt.def
	$(MAKE) -C graphics clean
	$(MAKE) -C farcall clean
