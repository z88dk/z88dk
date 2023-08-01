#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/math/integer/fast/*.asm" "$(NEWLIB_DIRECTORY)/math/integer/small/*.asm" "$(NEWLIB_DIRECTORY)/math/integer/*.asm"
NEWLIBR2KAGLOBS := "$(NEWLIB_DIRECTORY)/math/integer/r2ka/*.asm"
NEWLIBZXNGLOBS := "$(NEWLIB_DIRECTORY)/math/integer/z80n/*.asm"
NEWLIBZ180GLOBS := "$(NEWLIB_DIRECTORY)/math/integer/z180/*.asm"
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n obj/newlib-r2k obj/newlib-ixiy obj/newlib-z180 obj/newlib-ez80_z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS) $(OUTPUT_DIRECTORY)/fastmath.lib $(OUTPUT_DIRECTORY)/fastmath_ixiy.lib $(OUTPUT_DIRECTORY)/fastmath_z80n.lib \
	 $(OUTPUT_DIRECTORY)/fastmath_z180.lib \
	 $(OUTPUT_DIRECTORY)/fastmath_ez80_z80.lib

obj/newlib-z80:
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-r2k:
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2ka -D__CLASSIC $(NEWLIBGLOBS)
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2ka -D__CLASSIC $(NEWLIBR2KAGLOBS)

obj/newlib-z80n:
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBZXNGLOBS)

obj/newlib-z180:
	@$(ASSEMBLER) -d -O=obj/z180/x -I.. -mz180 -D__CLASSIC $(NEWLIBGLOBS)
	@$(ASSEMBLER) -d -O=obj/z180/x -I.. -mz180 -D__CLASSIC $(NEWLIBZ180GLOBS)

obj/newlib-ez80_z80:
	@$(ASSEMBLER) -d -O=obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(NEWLIBGLOBS)
	@$(ASSEMBLER) -d -O=obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(NEWLIBZ180GLOBS)

obj/newlib-ixiy:
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(NEWLIBGLOBS)

$(OUTPUT_DIRECTORY)/fastmath.lib: fastmath.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/fastmath.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_r2ka.lib: fastmath.lst
	TYPE=r2ka $(LIBLINKER) -mr2ka -x$(OUTPUT_DIRECTORY)/fastmath_r2ka.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_z80n.lib: fastmath.lst
	TYPE=z80n $(LIBLINKER) -mz80n -x$(OUTPUT_DIRECTORY)/fastmath_z80n.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_z180.lib: fastmath.lst
	TYPE=z180 $(LIBLINKER) -mz180 -x$(OUTPUT_DIRECTORY)/fastmath_z180.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_ez80_z80.lib: fastmath.lst
	TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -x$(OUTPUT_DIRECTORY)/fastmath_ez80_z80.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_ixiy.lib: fastmath.lst
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/fastmath_ixiy.lib @fastmath.lst

dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k obj/z180 obj/ez80_z80


clean:
	$(RM) -fr obj
	$(RM) zcc_opt.def
