#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/math/integer/fast/*.asm" "$(NEWLIB_DIRECTORY)/math/integer/small/*.asm" "$(NEWLIB_DIRECTORY)/math/integer/*.asm"
NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/math/integer/fast/*.asm $(NEWLIB_DIRECTORY)/math/integer/small/*.asm $(NEWLIB_DIRECTORY)/math/integer/*.asm
NEWLIBZ180GLOBS := "$(NEWLIB_DIRECTORY)/math/integer/z180/*.asm"
NEWLIBZ180GLOBS_ex := $(NEWLIB_DIRECTORY)/math/integer/z180/*.asm
NEWLIBZXNGLOBS := "$(NEWLIB_DIRECTORY)/math/integer/z80n/*.asm"
NEWLIBZXNGLOBS_ex := $(NEWLIB_DIRECTORY)/math/integer/z80n/*.asm
NEWLIBR2KAGLOBS := "$(NEWLIB_DIRECTORY)/math/integer/r2ka/*.asm"
NEWLIBR2KAGLOBS_ex := $(NEWLIB_DIRECTORY)/math/integer/r2ka/*.asm

NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n obj/newlib-r2ka obj/newlib-ixiy obj/newlib-z180 obj/newlib-ez80_z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

all: $(OUTPUT_DIRECTORY)/fastmath.lib $(OUTPUT_DIRECTORY)/fastmath_ixiy.lib \
	 $(OUTPUT_DIRECTORY)/fastmath_z180.lib \
	 $(OUTPUT_DIRECTORY)/fastmath_z80n.lib \
	 $(OUTPUT_DIRECTORY)/fastmath_r2ka.lib \
	 $(OUTPUT_DIRECTORY)/fastmath_ez80_z80.lib

obj/newlib-z80: $(NEWLIBGLOBS_ex)
	$(Q)$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)
	@touch $@

obj/newlib-r2ka: $(NEWLIBGLOBS_ex) $(NEWLIBR2KAGLOBS_ex)
	$(Q)$(ASSEMBLER) -d -O=obj/r2ka/x -I.. -mr2ka -D__CLASSIC $(NEWLIBGLOBS) $(NEWLIBR2KAGLOBS)
	@touch $@

obj/newlib-z80n: $(NEWLIBGLOBS_ex) $(NEWLIBZXNGLOBS_ex)
	$(Q)$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS) $(NEWLIBZXNGLOBS)
	@touch $@

obj/newlib-z180: $(NEWLIBGLOBS_ex) $(NEWLIBZ180GLOBS_ex)
	$(Q)$(ASSEMBLER) -d -O=obj/z180/x -I.. -mz180 -D__CLASSIC $(NEWLIBGLOBS) $(NEWLIBZ180GLOBS)
	@touch $@

obj/newlib-ez80_z80: $(NEWLIBGLOBS_ex) $(NEWLIBZ180GLOBS_ex)
	$(Q)$(ASSEMBLER) -d -O=obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(NEWLIBGLOBS) $(NEWLIBZ180GLOBS)
	@touch $@

obj/newlib-ixiy: $(NEWLIBGLOBS_ex)
	$(Q)$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(NEWLIBGLOBS)
	@touch $@

$(OUTPUT_DIRECTORY)/fastmath.lib: fastmath.lst obj/newlib-z80
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/fastmath.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_r2ka.lib: fastmath.lst obj/newlib-r2ka
	TYPE=r2ka $(LIBLINKER) -mr2ka -x$(OUTPUT_DIRECTORY)/fastmath_r2ka.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_z80n.lib: fastmath.lst obj/newlib-z80n
	TYPE=z80n $(LIBLINKER) -mz80n -x$(OUTPUT_DIRECTORY)/fastmath_z80n.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_z180.lib: fastmath.lst obj/newlib-z180
	TYPE=z180 $(LIBLINKER) -mz180 -x$(OUTPUT_DIRECTORY)/fastmath_z180.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_ez80_z80.lib: fastmath.lst obj/newlib-ez80_z80
	TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -x$(OUTPUT_DIRECTORY)/fastmath_ez80_z80.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_ixiy.lib: fastmath.lst obj/newlib-ixiy
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/fastmath_ixiy.lib @fastmath.lst


clean:
	$(RM) -fr obj
