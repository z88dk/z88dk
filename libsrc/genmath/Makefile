#
# Wahey, a messed up makefile for building libraries!
#

CFILES = \
	acos.c \
	asin.c \
	atan2.c \
	atof.c \
	cosh.c \
	ftoa.c \
	ftoe.c \
	pow.c \
	sinh.c \
	tanh.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: genmath

genmath: $(OBJECTS)
	z80asm -d -ns -nm -Mo -x../gen_math @genlist

.c.o:
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i $(AFILES)

