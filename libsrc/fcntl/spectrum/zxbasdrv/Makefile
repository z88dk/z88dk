#
# Makefile for the ZX BASIC driver
# (basic driven hardware abstraction layer)
#
# $Id: Makefile,v 1.5 2015-08-05 07:20:55 pauloscustodio Exp $


include ../../../Make.config

all:	open_z88.o read.o write.o rnd_loadblock.o rnd_saveblock.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/zxbasdrv @zxbdlst
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/zxbasdos @zxbdlst2

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
