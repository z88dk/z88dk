#
# Makefile for the Grundy NewBrain fcntl driver
#
# $Id: Makefile,v 1.6 2016-06-13 19:55:47 dom Exp $

include ../../Make.config

all:	read.o remove.o lseek.o rename.o
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/nbdrv @nbflst

.c.o:
	zcc +newbrain $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*

