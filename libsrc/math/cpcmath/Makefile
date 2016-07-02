#
# Wahey, a messed up makefile for building libraries!
#

include ../../Make.config

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
	tanh.c \
	atan2.c \
	atof.c \
	halfpi.c


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
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/cpc_math @cpclist

464_math: 
	$(MAKE) clean
	$(MAKE) objs
	$(LIBLINKER) -DforCPC464 -x$(OUTPUT_DIRECTORY)/464_math @468list

664_math: 
	$(MAKE) clean
	$(MAKE) objs
	$(LIBLINKER) -DforCPC664 -x$(OUTPUT_DIRECTORY)/664_math @468list

6128_math:
	$(MAKE) clean
	$(MAKE) objs
	$(LIBLINKER) -DforCPC6128 -x$(OUTPUT_DIRECTORY)/6128_math @468list

.c.o:
	zcc +cpc $(CFLAGS) -D__CPC__ -D__NATIVE_MATH__  $*.c

clean:
	$(RM) *.o* *.sym *.map *.err  zcc_opt.def *.i $(AFILES)
