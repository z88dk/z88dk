#
# Makefile for X-Motif graphics emulation
#
# $Id: Makefile,v 1.6 2016-06-11 19:01:45 dom Exp $

include ../../Make.config

CFILES = $(wildcard *.c)
OFILES = $(CFILES:.c=.o)

all:	$(OFILES)
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/x11 @x11.lst

%.o: %.c
	zcc +test -DMAKE_LIB $(CFLAGS) $^ -o $@

debug:	
	zcc +test -DMAKE_LIB -D_DEBUG_ $(CFLAGS) *.c
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/x11 @x11.lst

clean:
	$(RM) *.o* zcc_opt.def
