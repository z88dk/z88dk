#
# Makefile for the Grundy NewBrain fcntl driver
#
# $Id: Makefile,v 1.4 2009-01-07 18:27:22 stefano Exp $

include ../../Make.config

all:	open_z88.o read.o remove.o lseek.o rename.o
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/nbdrv @nbflst

.c.o:
	zcc +newbrain $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*

