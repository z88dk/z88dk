#
# Wahey, a messed up makefile for building libraries!
#

CFILES = \
	longjmp.c \
	setjmp.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	zcc -vn -make-lib $*.c

clean:
	rm -f *.o* *.sym *.map *~ *.err zcc_opt.def *.i $(AFILES)
