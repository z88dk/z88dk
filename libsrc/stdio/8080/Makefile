#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2002-05-09 09:47:05 dom Exp $
#

STDCFILES = \
	vfprintf_mini.c

AFILES  = $(STDCFILES:.c=.asm) $(NETCFILES:.c=.asm)
STDOBJECTS = $(STDCFILES:.c=.o)

generic: gen

gen:    $(STDOBJECTS)

z88_x:
	cd z88 ; make

.c.o:
	zcc -vn -make-lib $*.c

clean:
	rm -f *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
