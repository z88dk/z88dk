#
# Makefile for ZX Microdrive file support
#
# $Id: Makefile,v 1.2 2005-03-01 17:50:36 stefano Exp $



all:	open.o open_z88.o close.o readbyte.o remove.o rename.o lseek.o tell.o
	z80asm -d -ns -nm -Mo -x../../../zxmdv @mdvlist

.c.o:
	zcc +zx -vn -make-lib $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

