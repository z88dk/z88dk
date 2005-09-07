#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2005-09-07 01:30:34 aralbrec Exp $
#

STDCFILES = \
	fabandon.c \
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
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
