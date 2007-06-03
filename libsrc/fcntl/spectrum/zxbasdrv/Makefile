#
# Makefile for the ZX BASIC driver
# (basic driven hardware abstraction layer)
#
# $Id: Makefile,v 1.2 2007-06-03 15:13:06 stefano Exp $


include ../../../Make.config

all:	open_z88.o read.o write.o
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zxbasdrv @zxbdlst

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
