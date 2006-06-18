#
# Makefile for ZXVGS file support
#
# $Id: Makefile,v 1.3 2006-06-18 17:59:38 dom Exp $


include ../../Make.config

all:	open_z88.o

.c.o:
	zcc +zx $(CFLAGS) -DZXVGS $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

