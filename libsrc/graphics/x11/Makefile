#
# Makefile for X-Motif graphics emulation
#
# $Id: Makefile,v 1.1 2007-12-21 08:04:23 stefano Exp $

include ../../Make.config

all:	
	zcc $(CFLAGS) *.c
	$(LIBLINKER) -x../../x11.lib @x11.lst

clean:
	$(RM) *.o* zcc_opt.def
