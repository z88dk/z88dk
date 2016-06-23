#
# Makefile for ZXVGS file support
#
# $Id: Makefile,v 1.4 2016-06-23 20:31:34 dom Exp $


include ../../Make.config

all:	

.c.o:
	zcc +zx $(CFLAGS) -DZXVGS $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

