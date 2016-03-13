#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.8 2016-03-13 22:22:39 dom Exp $
#

include ../../Make.config

STDCFILES = \
	fchkstd.c  \
	fclose.c   \
	fgetc.c	   \
	fputc.c    \
	fputs.c    \
	ungetc.c   \
	vfprintf_mini.c

AFILES  = $(STDCFILES:.c=.asm) $(NETCFILES:.c=.asm)
STDOBJECTS = $(STDCFILES:.c=.o)

generic: gen

gen:    $(STDOBJECTS)

z88_x:
	cd z88 ; $(MAKE) ; cd ..

.c.o:
	zcc +test -DSIMPLIFIED_STDIO $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
