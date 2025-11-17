#
# Wahey, a messed up makefile for building libraries!
#

include ../../../Make.config

TARGET ?= test

#NEWLIBGLOBS := "$(Z88DK_LIBSRC)/math/float/math48/c/sccz80/*.asm" "$(Z88DK_LIBSRC)/math/float/math48/c/sdcc_ix/*.asm" "$(Z88DK_LIBSRC)/math/float/math48/lm/c/sccz80/*.asm" "$(Z88DK_LIBSRC)/math/float/math48/lm/c/sdcc_ix/*.asm" "$(Z88DK_LIBSRC)/math/float/math48/lm/z80/*.asm" "$(Z88DK_LIBSRC)/math/float/math48/z80/*.asm"

AFILES = $(wildcard c/smallc/*.asm)
CFILES  = $(wildcard cimpl/*.c) 
OBJECTS = $(CFILES:.c=.o) $(AFILES:.asm=.o)

CFLAGS += -DFLOAT_IS_48BITS

all: dirs $(OUTPUT_DIRECTORY)/math48.lib $(OUTPUT_DIRECTORY)/math48_ixiy.lib \
	$(OUTPUT_DIRECTORY)/math48_z80n.lib \
	$(OUTPUT_DIRECTORY)/math48_r2ka.lib \
	$(OUTPUT_DIRECTORY)/math48_r4k.lib \
	$(OUTPUT_DIRECTORY)/math48_z180.lib \
	$(OUTPUT_DIRECTORY)/math48_ez80_z80.lib \
	$(OUTPUT_DIRECTORY)/math48_kc160.lib


$(OUTPUT_DIRECTORY)/math48.lib: $(addprefix obj/z80/, $(OBJECTS))
	@$(ASSEMBLER) -d -O=obj/z80/ -I.. -mz80 -D__CLASSIC @math48impl.lst
	TYPE=z80 $(LIBLINKER) -mz80 -x$(OUTPUT_DIRECTORY)/math48 @math48.lst

$(OUTPUT_DIRECTORY)/math48_z180.lib: $(addprefix obj/z180/, $(OBJECTS))
	@$(ASSEMBLER) -d -O=obj/z180/ -I.. -mz180 -D__CLASSIC @math48impl.lst
	TYPE=z180 $(LIBLINKER) -mz180 -x$(OUTPUT_DIRECTORY)/math48_z180 @math48.lst

$(OUTPUT_DIRECTORY)/math48_z80n.lib: $(addprefix obj/z80n/, $(OBJECTS))
	@$(ASSEMBLER) -d -O=obj/z80n/ -I.. -mz80n -D__CLASSIC @math48impl.lst
	TYPE=z80n $(LIBLINKER) -mz80n -x$(OUTPUT_DIRECTORY)/math48_z80n @math48.lst

$(OUTPUT_DIRECTORY)/math48_ez80_z80.lib: $(addprefix obj/ez80_z80/, $(OBJECTS))
	@$(ASSEMBLER) -d -O=obj/ez80_z80/ -I.. -mez80_z80 -D__CLASSIC @math48impl.lst
	TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -x$(OUTPUT_DIRECTORY)/math48_ez80_z80 @math48.lst

$(OUTPUT_DIRECTORY)/math48_kc160.lib: $(addprefix obj/kc160/, $(OBJECTS))
	@$(ASSEMBLER) -d -O=obj/kc160/ -I.. -mkc160 -D__CLASSIC @math48impl.lst
	TYPE=kc160 $(LIBLINKER) -mkc160 -x$(OUTPUT_DIRECTORY)/math48_kc160 @math48.lst

$(OUTPUT_DIRECTORY)/math48_r2ka.lib: $(addprefix obj/r2ka/, $(OBJECTS))
	@$(ASSEMBLER) -d -O=obj/r2ka/ -I.. -mr2ka -D__CLASSIC @math48impl.lst
	TYPE=r2ka $(LIBLINKER) -mr2ka -x$(OUTPUT_DIRECTORY)/math48_r2ka @math48.lst

$(OUTPUT_DIRECTORY)/math48_r4k.lib: $(addprefix obj/r4k/, $(OBJECTS))
	@$(ASSEMBLER) -d -O=obj/r4k/ -I.. -mr4k -D__CLASSIC @math48impl.lst
	TYPE=r4k $(LIBLINKER) -mr4k -x$(OUTPUT_DIRECTORY)/math48_r4k @math48.lst

$(OUTPUT_DIRECTORY)/math48_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	@$(ASSEMBLER) -d -O=obj/ixiy/ -I.. -mz80 -IXIY -D__CLASSIC @math48impl.lst
	TYPE=ixiy $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math48_ixiy -IXIY @math48.lst

dirs:
	@mkdir -p obj/z80/cimpl obj/ixiy/cimpl obj/r2ka/cimpll obj/z80n/cimpl obj/z180/cimpl obj/ez80_z80/cimpl obj/kc160/cimpl obj/r4k/cimpl obj/r2ka/cimpl

.PHONY: dirs

clean:
	$(RM) -fr obj
