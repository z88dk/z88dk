#
# Make C128 graphics libs (only the C code portions)
#
# $Id: Makefile,v 1.1 2008-07-17 15:39:56 stefano Exp $
#

include ../../Make.config

CIAFILES = \
	clg.c

CIAOBJECTS = $(CIAFILES:.c=.o)

AFILES  = $(CIAFILES:.c=.asm)

all:    $(CIAOBJECTS)

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
