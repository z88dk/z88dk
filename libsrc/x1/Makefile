#
# Build the X1 target libraries
#
# $Id: Makefile,v 1.2 2013-11-12 13:50:15 stefano Exp $
#

include ../Make.config


AFILES = \
	subcpu_command.c \
	subcpu_set.c \
	subcpu_get.c

AOBJECTS = $(AFILES:.c=.o)


all:    $(AOBJECTS)


.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i
