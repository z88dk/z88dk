#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.2 2001-05-03 09:06:38 dom Exp $



all:	close.o fabandon.o findhand.o freehand.o open.o open_z88.o \
	read.o readbyte.o write.o writebyte.o
	z80asm -d -ns -nm -Mo -x../../../p3 @p3list

.c.o:
	zcc +zx -vn -make-lib -DPLUS3 $*.c

clean:
	rm -f *.o* zcc_opt.def
	

