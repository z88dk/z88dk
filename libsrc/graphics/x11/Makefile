#
# Makefile for X-Motif graphics emulation
#
# $Id: Makefile,v 1.4 2011-10-19 10:56:32 stefano Exp $

include ../../Make.config

all:	
	zcc +test -DMAKE_LIB $(CFLAGS) *.c
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/x11 @x11.lst

clean:
	$(RM) *.o* zcc_opt.def
