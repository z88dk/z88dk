#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.16 2010-11-18 15:42:20 stefano Exp $

include ../Make.config

lz88: time z88_time

lpps: time pps_time

lzx: spectrum_time

lnewbrain: newbrain_time

time: gmtime.o localtime.o mktime.o

.c.o:
	zcc +test $(CFLAGS) $*.c

pps_time:
	cd sprinter ; $(MAKE) ; cd ..

z88_time:
	cd z88 ; $(MAKE) ; cd ..

spectrum_time:
	cd spectrum ; $(MAKE) ; cd ..

newbrain_time:
	cd newbrain ; $(MAKE) ; cd ..

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
	$(RM) zx81/*.o*
	$(RM) ace/*.o*
	$(RM) newbrain/*.o*
	$(RM) rcmx000/*.o*
	cd z88 ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
	cd sprinter ; $(MAKE) clean ; cd ..
