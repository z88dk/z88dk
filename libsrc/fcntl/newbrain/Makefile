#
# Makefile for the Grundy NewBrain fcntl driver
#
# $Id: Makefile,v 1.2 2007-06-11 07:07:23 stefano Exp $

include ../../Make.config

all:	open_z88.o read.o remove.o rename.o
	$(LIBLINKER) -x../../nbdrv @nbflst

.c.o:
	zcc +newbrain $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*

