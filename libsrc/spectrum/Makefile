#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.4 2007-06-13 00:03:13 aralbrec Exp $

include ../Make.config


all:	tape_save.o

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
