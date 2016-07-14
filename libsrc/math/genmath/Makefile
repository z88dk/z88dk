#
# Wahey, a messed up makefile for building libraries!
# $Id: Makefile,v 1.4 2016-07-14 13:30:11 pauloscustodio Exp $
#

include ../../Make.config

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: zx81math genmath

genmath: $(OBJECTS)
	zcc +test $(CFLAGS) acos.c
	zcc +test $(CFLAGS) asin.c
	zcc +test $(CFLAGS) atan2.c
	zcc +test $(CFLAGS) atof.c
	zcc +test $(CFLAGS) cosh.c
	zcc +test $(CFLAGS) ftoa.c
	zcc +test $(CFLAGS) ftoe.c
	zcc +test $(CFLAGS) pow.c
	zcc +test $(CFLAGS) sinh.c
	zcc +test $(CFLAGS) tanh.c
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/gen_math @genlist

zx81math:
	$(RM) -f *.o
	zcc +test $(CFLAGS) -Ca--IXIY acos.c
	zcc +test $(CFLAGS) -Ca--IXIY asin.c
	zcc +test $(CFLAGS) -Ca--IXIY atan2.c
	zcc +test $(CFLAGS) -Ca--IXIY atof.c
	zcc +test $(CFLAGS) -Ca--IXIY cosh.c
	zcc +test $(CFLAGS) -Ca--IXIY ftoa.c
	zcc +test $(CFLAGS) -Ca--IXIY ftoe.c
	zcc +test $(CFLAGS) -Ca--IXIY pow.c
	zcc +test $(CFLAGS) -Ca--IXIY sinh.c
	zcc +test $(CFLAGS) -Ca--IXIY tanh.c
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zx81_math --IXIY @zx81list
	$(RM) -f *.o

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i $(AFILES)

