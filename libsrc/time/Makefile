#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.9 2002-11-20 22:52:59 dom Exp $

lz88: time z88_time

lpps: time pps_time

lzx: spectrum_time

time: gmtime.o localtime.o mktime.o

.c.o:
	zcc +z88 -vn -make-lib $*.c

pps_time:
	cd sprinter ; $(MAKE)

z88_time:
	cd z88 ; $(MAKE)

spectrum_time:
	cd spectrum ; $(MAKE)

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
	$(RM) zx81/*.o*
	cd z88 ; $(MAKE) clean
	cd spectrum ; $(MAKE) clean
	cd sprinter ; $(MAKE) clean
