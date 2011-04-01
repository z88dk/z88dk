#
# Make Enterprise 64/128 HRG graphics lib (only the C code portions)
#
# $Id: Makefile,v 1.1 2011-04-01 06:50:45 stefano Exp $
#

include ../../Make.config

EPFILES = \
	clg.c circle.c uncircle.c setxy.c fill.c \
	draw.c drawr.c drawto.c \
	undraw.c undrawr.c undrawto.c \
	plot.c  unplot.c xorplot.c

EPOBJECTS = $(EPFILES:.c=.o)

AFILES  = $(EPFILES:.c=.asm)

all:    $(EPOBJECTS)

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
