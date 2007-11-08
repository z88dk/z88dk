#
# Wahey, a messed up makefile for building libraries!
# $Id: Makefile,v 1.20 2007-11-08 14:11:50 stefano Exp $
#

include ../Make.config

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
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/gen_math @genlist

.c.o:
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i $(AFILES)

