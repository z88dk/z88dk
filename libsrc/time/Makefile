#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.7 2002-07-15 15:34:07 dom Exp $

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
	rm -f *.o* *.i *.sym *.map zcc_opt.def
	rm -f zx81/*.o*
	cd z88 ; $(MAKE) clean
	cd spectrum ; $(MAKE) clean
