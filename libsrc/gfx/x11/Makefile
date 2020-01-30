#
# Makefile for X-Motif graphics emulation
#
# $Id: Makefile,v 1.7 2016-07-02 15:42:55 dom Exp $

include ../../Make.config

CFILES = $(wildcard *.c)
AFILES = $(wildcard *.asm)
OFILES = $(CFILES:.c=.o) $(AFILES:.asm=.o)

all: dirs $(addprefix  obj/z80/,$(OFILES)) $(addprefix obj/ixiy/,$(OFILES)) $(addprefix obj/r2k/,$(OFILES)) $(addprefix obj/8080/,$(OFILES)) $(addprefix obj/gbz80/,$(OFILES)) $(addprefix obj/z180/,$(OFILES))  $(addprefix obj/z80n/,$(OFILES))




#all:	$(OFILES)
#	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/x11 @x11.lst

dirs:
	@mkdir -p obj/z80 obj/z180 obj/ixiy obj/z80n obj/r2k obj/8080 obj/gbz80

clean:
	$(RM) -r obj zcc_opt.def
