#
# Makefile for ZXVGS file support
#
# $Id: Makefile,v 1.2 2003-03-22 14:17:35 dom Exp $



all:	open_z88.o

.c.o:
	zcc +zx -vn -make-lib -DZXVGS $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

