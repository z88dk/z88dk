#
# Make CP/M GSX graphics lib (only the C code portions)
#
# $Id: Makefile $
#

include ../../../Make.config

EPFILES = \
	clg.c setxy.c \
	plot.c   draw.c    drawb.c   drawr.c   drawto.c \
	unplot.c undraw.c  undrawb.c undrawr.c undrawto.c \
	xorplot.c
	

EPOBJECTS = $(EPFILES:.c=.o)

AFILES  = $(EPFILES:.c=.asm)

all:    $(EPOBJECTS)

.c.o:
	$(ZCC) +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
