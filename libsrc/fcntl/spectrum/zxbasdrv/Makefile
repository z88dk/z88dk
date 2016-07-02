#
# Makefile for the ZX BASIC driver
# (basic driven hardware abstraction layer)
#
# $Id: Makefile,v 1.7 2016-07-02 15:41:39 dom Exp $


include ../../../Make.config

OBJECTS = read.o write.o rnd_loadblock.o rnd_saveblock.o

all: $(OUTPUT_DIRECTORY)/zxbasdrv.lib $(OUTPUT_DIRECTORY)/zxbasdos.lib


$(OUTPUT_DIRECTORY)/zxbasdos.lib: $(OBJECTS) zxbdlst2 $(wildcard *.asm)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zxbasdos @zxbdlst2


$(OUTPUT_DIRECTORY)/zxbasdrv.lib: $(OBJECTS) zxbdlst $(wildcard *.asm)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zxbasdrv @zxbdlst

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* $(OUTPUT_DIRECTORY)/zxbasdrv.lib $(OUTPUT_DIRECTORY)/zxbasdos.lib
