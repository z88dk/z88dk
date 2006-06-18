#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.3 2006-06-18 17:59:39 dom Exp $

include ../Make.config


all:	tape_save.o tape_save_block.o tape_load_block.o

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
