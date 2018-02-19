#
# Wahey, a messed up makefile for building libraries!
# $Id: Makefile,v 1.4 2016-07-14 13:30:11 pauloscustodio Exp $
#

include ../../Make.config

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: zx81math genmath

genmath: $(OBJECTS)
	$(ZCC) +test $(CFLAGS) acos.c
	$(ZCC) +test $(CFLAGS) asin.c
	$(ZCC) +test $(CFLAGS) atan2.c
	$(ZCC) +test $(CFLAGS) atof.c
	$(ZCC) +test $(CFLAGS) cosh.c
	$(ZCC) +test $(CFLAGS) ftoa.c
	$(ZCC) +test $(CFLAGS) ftoe.c
	$(ZCC) +test $(CFLAGS) pow.c
	$(ZCC) +test $(CFLAGS) sinh.c
	$(ZCC) +test $(CFLAGS) tanh.c
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/gen_math @genlist

zx81math:
	$(RM) -f *.o
	$(ZCC) +test $(CFLAGS) -Ca--IXIY acos.c
	$(ZCC) +test $(CFLAGS) -Ca--IXIY asin.c
	$(ZCC) +test $(CFLAGS) -Ca--IXIY atan2.c
	$(ZCC) +test $(CFLAGS) -Ca--IXIY atof.c
	$(ZCC) +test $(CFLAGS) -Ca--IXIY cosh.c
	$(ZCC) +test $(CFLAGS) -Ca--IXIY ftoa.c
	$(ZCC) +test $(CFLAGS) -Ca--IXIY ftoe.c
	$(ZCC) +test $(CFLAGS) -Ca--IXIY pow.c
	$(ZCC) +test $(CFLAGS) -Ca--IXIY sinh.c
	$(ZCC) +test $(CFLAGS) -Ca--IXIY tanh.c
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zx81_math --IXIY @zx81list
	$(RM) -f *.o

.c.o:
	$(ZCC) +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i $(AFILES)

