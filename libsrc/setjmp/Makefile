#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

CFILES = \
	longjmp.c \
	setjmp.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i $(AFILES)
