#
# Makefile for the Grundy NewBrain fcntl driver
#
# $Id: Makefile,v 1.3 2007-06-11 14:41:04 stefano Exp $

include ../../Make.config

all:	open_z88.o read.o remove.o rename.o
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/nbdrv @nbflst

.c.o:
	zcc +newbrain $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*

