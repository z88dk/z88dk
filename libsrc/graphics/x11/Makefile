#
# Makefile for X-Motif graphics emulation
#
# $Id: Makefile,v 1.7 2016-07-02 15:42:55 dom Exp $

include ../../Make.config

CFILES = $(wildcard *.c)
OFILES = $(CFILES:.c=.o)

all:	$(OFILES)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/x11 @x11.lst

%.o: %.c
	$(ZCC) +test -DMAKE_LIB $(CFLAGS) $^ -o $@

debug:	
	$(ZCC) +test -DMAKE_LIB -D_DEBUG_ $(CFLAGS) *.c
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/x11 @x11.lst

clean:
	$(RM) *.o* zcc_opt.def
