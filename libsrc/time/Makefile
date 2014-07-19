#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.25 2014-07-19 11:32:21 pauloscustodio Exp $

include ../Make.config

lcpm: time cpm_time

lz88: time z88_time

lpps: time pps_time

lzx: spectrum_time

lnewbrain: newbrain_time

lenterprise: enterprise_time

lx1: time x1_time

time: gmtime.o localtime.o mktime.o

.c.o:
	zcc +test $(CFLAGS) $*.c

pps_time:
	cd sprinter ; $(MAKE) ; cd ..

z88_time:
	cd z88 ; $(MAKE) ; cd ..

spectrum_time:
	$(RM) time.o
	zcc +test -D__SPECTRUM__ $(CFLAGS) time.c
	cd spectrum ; $(MAKE) ; cd ..

newbrain_time:
	cd newbrain ; $(MAKE) ; cd ..

enterprise_time:
	cd enterprise ; $(MAKE) ; cd ..

cpm_time:
	cd cpm ; $(MAKE) ; cd ..

x1_time:
	cd x1 ; $(MAKE) ; cd ..

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
	$(RM) zx81/*.o*
	$(RM) ace/*.o*
	$(RM) cpm/*.o*
	$(RM) enterprise/*.o*
	$(RM) newbrain/*.o*
	$(RM) osca/*.o*
	$(RM) p2000/*.o*
	$(RM) rcmx000/*.o*
	$(RM) mc1000/*.o*
	cd x1 ; $(MAKE) clean ; cd ..
	cd z88 ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
	cd sprinter ; $(MAKE) clean ; cd ..
