#
# Makefile for ESXDOS file support
#
# $Id: Makefile,v 1.9 2016-07-02 15:41:39 dom Exp $

include ../../../../../Make.config

CFILES = $(wildcard *.c)
AFILES = $(wildcard *.asm)

CLASSIC_OBJECTS = $(addprefix obj/,$(CFILES:.c=.o)) $(addprefix obj/,$(AFILES:.asm=.o))

NEWLIBGLOBS := 

all: dirs $(OUTPUT_DIRECTORY)/esxdos.lib

.PHONY: dirs 

$(OUTPUT_DIRECTORY)/esxdos.lib: $(CLASSIC_OBJECTS) esxdos.lst
	$(LIBLINKER) -I$(Z88DK_LIB) -x$(OUTPUT_DIRECTORY)/esxdos @esxdos.lst

obj/%.o: %.c
	$(ZCC) +zx $(CFLAGS) -DESXDOS -o $@ $^

obj/%.o: %.asm
	$(ZCC) +zx $(CFLAGS) -DESXDOS -o $@ $^

dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k

clean:
	$(RM) -fr obj
