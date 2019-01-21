#
# Wahey, a messed up makefile for building libraries!
# $Id: Makefile,v 1.4 2016-07-14 13:30:11 pauloscustodio Exp $
#

include ../../Make.config

AFILES  = $(wildcard *.asm)
CFILES  = $(wildcard *.c)
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

all: dirs $(OUTPUT_DIRECTORY)/genmath.lib $(OUTPUT_DIRECTORY)/genmath_iy.lib $(OUTPUT_DIRECTORY)/genmath_zx81.lib


$(OUTPUT_DIRECTORY)/genmath.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/genmath @genmath.lst

$(OUTPUT_DIRECTORY)/genmath_iy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	TYPE=ixiy $(LIBLINKER) --IXIY -x$(OUTPUT_DIRECTORY)/genmath_iy @genmath.lst

$(OUTPUT_DIRECTORY)/genmath_zx81.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	TYPE=ixiy $(LIBLINKER) --IXIY -x$(OUTPUT_DIRECTORY)/genmath_zx81 @genmathzx81.lst

dirs:
	@mkdir -p obj/z80 obj/zx81 obj/ixiy

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

