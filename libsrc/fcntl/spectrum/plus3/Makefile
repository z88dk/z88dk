#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.3 2002-10-22 19:15:05 dom Exp $



all:	close.o fabandon.o findhand.o freehand.o open.o open_z88.o \
	read.o readbyte.o write.o writebyte.o
	z80asm -d -ns -nm -Mo -x../../../p3 @p3list

.c.o:
	zcc +zx -vn -make-lib -DPLUS3 $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

