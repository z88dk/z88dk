#
# Makefile for X-Motif graphics emulation
#
# $Id: Makefile,v 1.3 2008-03-27 08:51:23 stefano Exp $

include ../../Make.config

all:	
	zcc +test $(CFLAGS) *.c
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/x11 @x11.lst

clean:
	$(RM) *.o* zcc_opt.def
