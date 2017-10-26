#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

CFILES = \
	l_longjmp.c \
	l_setjmp.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

generic_iy:
	zcc +test $(CFLAGS) -Ca--IXIY longjmp.c
	zcc +test $(CFLAGS) -Ca--IXIY setjmp.c

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i $(AFILES)
