#
# Build the Enterprise 64/128 target libraries
#
# $Id: Makefile,v 1.1 2011-03-14 11:36:48 stefano Exp $
#

include ../Make.config


AFILES = \
	exos_set_vmode.c

AOBJECTS = $(AFILES:.c=.o)


all:    $(AOBJECTS)


.c.o:
	zcc +enterprise $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i
