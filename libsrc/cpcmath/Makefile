#
# Wahey, a messed up makefile for building libraries!
#

CFILES = \
	amax.c \
	amin.c \
	ceil.c \
	fabs.c \
	fmod.c \
	ftoa.c \
	ftoe.c \
	cosh.c \
	sinh.c \
	tanh.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)


all: l464_math l664_math l6128_math lcpc_math


objs:	$(OBJECTS)

l464_math: 464_math

l664_math: 664_math

l6128_math: 6128_math

lcpc_math: cpc_math

cpc_math: 
	$(MAKE) clean
	$(MAKE) objs
	z80asm -d -ns -nm -Mo -x../cpc_math @cpclist

464_math: 
	$(MAKE) clean
	$(MAKE) objs
	z80asm -d -ns -nm -Mo -DforCPC464 -x../464_math @468list

664_math: 
	$(MAKE) clean
	$(MAKE) objs
	z80asm -d -ns -nm -Mo -DforCPC664 -x../664_math @468list

6128_math:
	$(MAKE) clean
	$(MAKE) objs
	z80asm -d -ns -nm -Mo -DforCPC6128 -x../6128_math @468list

.c.o:
	zcc -vn -D__CPC__ -make-lib $*.c

clean:
	$(RM) *.o* *.sym *.map *.err  zcc_opt.def
