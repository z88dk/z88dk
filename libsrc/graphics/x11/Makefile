#
# Makefile for X-Motif graphics emulation
#
# $Id: Makefile,v 1.2 2008-03-05 20:35:46 dom Exp $

include ../../Make.config

all:	
	zcc +test $(CFLAGS) *.c
	$(LIBLINKER) -x../../x11.lib @x11.lst

clean:
	$(RM) *.o* zcc_opt.def
