#
# Makefile for ZXVGS file support
#
# $Id: Makefile,v 1.1 2003-03-22 14:10:24 dom Exp $



all:	open_z88.o
	z80asm -d -ns -nm -Mo -x../../../zxvgs @zxvgslst

.c.o:
	zcc +zx -vn -make-lib -DZXVGS $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

