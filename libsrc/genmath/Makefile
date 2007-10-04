#
# Wahey, a messed up makefile for building libraries!
# $Id: Makefile,v 1.18 2007-10-04 20:16:12 stefano Exp $
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

all: genmath genmathiy

genmath: $(OBJECTS)
	$(LIBLINKER) -x$../$(OUTPUT_DIRECTORY)/gen_math @genlist

genmathiy:
	$(RM) *.o*
	zcc $(CFLAGS) -Ca-IXIY acos.c
	zcc $(CFLAGS) -Ca-IXIY asin.c
	zcc $(CFLAGS) -Ca-IXIY atan2.c
	zcc $(CFLAGS) -Ca-IXIY atof.c
	zcc $(CFLAGS) -Ca-IXIY cosh.c
	zcc $(CFLAGS) -Ca-IXIY ftoa.c
	zcc $(CFLAGS) -Ca-IXIY ftoe.c
	zcc $(CFLAGS) -Ca-IXIY pow.c
	zcc $(CFLAGS) -Ca-IXIY sinh.c
	zcc $(CFLAGS) -Ca-IXIY tanh.c 
	$(LIBLINKER) -IXIY -x$../$(OUTPUT_DIRECTORY)/gen_math_iy @genlist
	$(RM) *.o*

.c.o:
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i $(AFILES)

