#
# Makefile for Jupiter ACE target specific lib - tape I/O
#
# $Id: Makefile,v 1.1 2010-05-31 08:29:06 stefano Exp $
#

include ../../Make.config

CIAFILES = \
	tape_save.c

CIAOBJECTS = $(CIAFILES:.c=.o)

AFILES  = $(CIAFILES:.c=.asm)

all:    $(CIAOBJECTS)

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
