#
# Wahey, a messed up makefile for building libraries!
# $Id: Makefile,v 1.19 2007-10-09 20:05:04 stefano Exp $
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
	$(LIBLINKER) -x$../$(OUTPUT_DIRECTORY)/gen_math @genlist

.c.o:
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i $(AFILES)

