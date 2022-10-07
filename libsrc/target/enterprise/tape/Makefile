#
# Make Enterprise 64/128 graphics libs (only the C code portions)
#
# $Id: Makefile,v 1.1 2011-04-01 06:50:45 stefano Exp $
#

include ../../../Make.config

EPFILES = \
	tape_load_block.c tape_save_block.c tape_save.c

EPOBJECTS = $(EPFILES:.c=.o)

AFILES  = $(EPFILES:.c=.asm)

all:    $(EPOBJECTS)

.c.o:
	$(ZCC) +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
