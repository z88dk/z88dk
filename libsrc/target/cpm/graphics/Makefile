#
# Make CP/M GSX graphics lib (only the C code portions)
#
# $Id: Makefile $
#

include ../../../Make.config

EPFILES = \
	clg.c      clga.c      setxy.c     move.c\
	plot.c     unplot.c    xorplot.c \
	draw.c     drawb.c     drawr.c     drawto.c \
	undraw.c   undrawb.c   undrawr.c   undrawto.c \
	xordraw.c  xordrawb.c  xordrawr.c  xordrawto.c
	
	

EPOBJECTS = $(EPFILES:.c=.o)

AFILES  = $(EPFILES:.c=.asm)

all:    $(EPOBJECTS)

.c.o:
	$(ZCC) +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
