#
# Makefile for X-Motif graphics emulation
#
# $Id: Makefile,v 1.5 2012-10-24 06:44:12 stefano Exp $

include ../../Make.config

all:	
	zcc +test -DMAKE_LIB $(CFLAGS) *.c
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/x11 @x11.lst

debug:	
	zcc +test -DMAKE_LIB -D_DEBUG_ $(CFLAGS) *.c
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/x11 @x11.lst

clean:
	$(RM) *.o* zcc_opt.def
