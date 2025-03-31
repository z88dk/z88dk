#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile $

include ../../../../Make.config

CFILES = rs232_close.c rs232_get.c rs232_init.c rs232_params.c rs232_put.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all:	$(OUTPUT_DIRECTORY)/rs232morex.lib

$(OUTPUT_DIRECTORY)/rs232morex.lib: $(OBJECTS)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/rs232morex @morexlist

%.o: %.c
	$(ZCC) +zx $(CFLAGS) $*.c -o $@

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
