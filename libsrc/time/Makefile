#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.8 2002-10-22 19:15:24 dom Exp $

lz88: time z88_time

lzx: spectrum_time

time: gmtime.o localtime.o

.c.o:
	zcc +z88 -vn -make-lib $*.c

z88_time:
	cd z88 ; $(MAKE)

spectrum_time:
	cd spectrum ; $(MAKE)

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
	$(RM) zx81/*.o*
	cd z88 ; $(MAKE) clean
	cd spectrum ; $(MAKE) clean
