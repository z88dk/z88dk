#
# Makefile for the Grundy NewBrain fcntl driver
#
# $Id: Makefile,v 1.7 2016-07-02 15:41:39 dom Exp $

include ../../Make.config

OBJECTS = read.o remove.o lseek.o rename.o
all: $(OUTPUT_DIRECTORY)/nbdrv.lib

$(OUTPUT_DIRECTORY)/nbdrv.lib: $(OBJECTS) $(wildcard *.asm) nbflst
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/nbdrv @nbflst

.c.o:
	zcc +newbrain $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* $(OUTPUT_DIRECTORY)/nbdrv.lib

