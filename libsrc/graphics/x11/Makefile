#
# Makefile for X-Motif graphics emulation
#
# $Id: Makefile,v 1.7 2016-07-02 15:42:55 dom Exp $

include ../../Make.config

CFILES = $(wildcard *.c)
AFILES = $(wildcard *.asm)
OFILES = $(CFILES:.c=.o) $(AFILES:.asm=.o)

#all: dirs $(addprefix  obj/z80/,$(OFILES)) $(addprefix obj/ixiy/,$(OFILES)) $(addprefix obj/r2k/,$(OFILES)) $(addprefix obj/8080/,$(OFILES)) $(addprefix obj/gbz80/,$(OFILES)) $(addprefix  obj/z180/,$(OFILES))
all: dirs  ../../x11.lib ../../x11_gbz80.lib ../../x11_r2k.lib ../../x11_8080.lib ../../x11_z180.lib ../../x11_ixiy.lib ../../x11_z80n.lib

#$(addprefix  obj/z80/,$(OFILES)) $(addprefix obj/ixiy/,$(OFILES)) $(addprefix obj/r2k/,$(OFILES)) $(addprefix obj/8080/,$(OFILES)) $(addprefix obj/gbz80/,$(OFILES)) $(addprefix  obj/z180/,$(OFILES))


../../x11.lib: $(addprefix  obj/z80/,$(OFILES))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/x11 @x11.lst

../../x11_ixiy.lib: $(addprefix obj/ixiy/,$(OFILES))
	TYPE=ixiy $(LIBLINKER) --IXIY  -x$@ @x11.lst

../../x11_r2k.lib: $(addprefix obj/r2k/,$(OFILES))
	TYPE=r2k $(LIBLINKER) -mr2k  -x$@ @x11.lst

../../x11_8080.lib: $(addprefix obj/8080/,$(OFILES))
	TYPE=8080 $(LIBLINKER) -m8080 -x$@ @x11.lst

../../x11_z180.lib: $(addprefix obj/z180/,$(OFILES))
	TYPE=z180 $(LIBLINKER) -mz180 -x$@ @x11.lst

../../x11_gbz80.lib: $(addprefix obj/gbz80/,$(OFILES))
	TYPE=gbz80 $(LIBLINKER) -mgbz80 -x$@ @x11.lst

../../x11_z80n.lib: $(addprefix obj/z80n/,$(OFILES))
	TYPE=z80n $(LIBLINKER) -mz80n -x$@ @x11.lst



#all:	$(OFILES)
#	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/x11 @x11.lst

dirs:
	@mkdir -p obj/z80 obj/z180 obj/ixiy obj/z80n obj/r2k obj/8080 obj/gbz80

clean:
	$(RM) -r obj zcc_opt.def
