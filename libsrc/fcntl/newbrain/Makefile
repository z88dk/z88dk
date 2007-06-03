#
# Makefile for the Grundy NewBrain fcntl driver
#
# $Id: Makefile,v 1.1 2007-06-03 15:13:06 stefano Exp $

include ../../Make.config

all:	open_z88.o read.o
	$(LIBLINKER) -x../../nbdrv @nbflst

.c.o:
	zcc +newbrain $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*

