#
# $Id: Makefile,v 1.9 2016-07-02 16:15:37 dom Exp $

include ../Make.config

CFILES = dump.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OUTPUT_DIRECTORY)/debug.lib

$(OUTPUT_DIRECTORY)/debug.lib: $(OBJECTS) $(wildcard *.asm) debug.lst
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/debug @debug.lst

.c.o:  
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
