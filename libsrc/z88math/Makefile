#
# Wahey, a messed up makefile for building libraries!
#

CFILES = \
	cosh.c \
	sinh.c \
	tanh.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)


all: z88math


z88math: $(OBJECTS)
	z80asm -d -ns -nm -Mo -x../z88_math @z88list

.c.o:
	zcc -vn -math-z88 -D__Z88__ -D__NATIVE_MATH__ -make-lib $*.c


clean:
	$(RM) *.o* *.sym *.map *.err 
