#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2001-04-30 14:34:16 dom Exp $

lz88: time z88_time

lzx: spectrum_time

time: gmtime.o localtime.o

.c.o:
	zcc +z88 -vn -make-lib $*.c

z88_time:
	cd z88 ; make

spectrum_time:
	cd spectrum ; make

clean:
	rm -f *.o* *.i *.sym *.map zcc_opt.def
	cd z88 ; make clean
	cd spectrum ; make clean
