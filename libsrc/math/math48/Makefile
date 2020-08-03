#
# Wahey, a messed up makefile for building libraries!
#

include ../../Make.config

TARGET ?= test

#NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/math/float/math48/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/math/float/math48/c/sdcc_ix/*.asm" "$(NEWLIB_DIRECTORY)/math/float/math48/lm/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/math/float/math48/lm/c/sdcc_ix/*.asm" "$(NEWLIB_DIRECTORY)/math/float/math48/lm/z80/*.asm" "$(NEWLIB_DIRECTORY)/math/float/math48/z80/*.asm"

AFILES = $(wildcard *.asm)
CFILES  = $(wildcard *.c)
OBJECTS = $(CFILES:.c=.o) $(AFILES:.asm=.o)


all: dirs $(OUTPUT_DIRECTORY)/math48.lib $(OUTPUT_DIRECTORY)/math48_iy.lib


$(OUTPUT_DIRECTORY)/math48.lib: $(addprefix obj/z80/, $(OBJECTS))
	@$(ASSEMBLER) -d -O=obj/z80/x/x -I.. -mz80 -D__CLASSIC @newlibfiles.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math48 @math48.lst

$(OUTPUT_DIRECTORY)/math48_iy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	@$(ASSEMBLER) -d -O=obj/ixiy/x/x -I.. -mz80 -IXIY -D__CLASSIC @newlibfiles.lst
	TYPE=ixiy $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math48_iy -IXIY @math48.lst

dirs:
	@mkdir -p obj/z80 obj/ixiy obj/r2k

.PHONY: dirs

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i
	$(RM) -fr obj
