#
# Makefile for the ZX BASIC driver
# (basic driven hardware abstraction layer)
#
# $Id: Makefile,v 1.1 2006-07-18 21:02:54 stefano Exp $


include ../../../Make.config

all:	open_z88.o read.o write.o
	$(LIBLINKER) -x../../../zxbasdrv @zxbdlst

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
