#
# Makefile for S-OS
#
# $Id: Makefile,v 1.1 2013-12-05 09:34:01 stefano Exp $
#

include ../../Make.config

CIAFILES = \
	tape_save.c \
	tape_save_block.c \
	tape_load.c \
	tape_load_block.c

CIAOBJECTS = $(CIAFILES:.c=.o)

AFILES  = $(CIAFILES:.c=.asm)

all:    $(CIAOBJECTS)

.c.o:
	zcc +test -DBUILDING_SOSLIB $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
