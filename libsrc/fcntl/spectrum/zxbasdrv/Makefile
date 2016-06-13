#
# Makefile for the ZX BASIC driver
# (basic driven hardware abstraction layer)
#
# $Id: Makefile,v 1.6 2016-06-13 19:55:48 dom Exp $


include ../../../Make.config

all:	read.o write.o rnd_loadblock.o rnd_saveblock.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/zxbasdrv @zxbdlst
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/zxbasdos @zxbdlst2

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
