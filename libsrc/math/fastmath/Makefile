#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/math/integer/fast/*.asm" "$(NEWLIB_DIRECTORY)/math/integer/small/*.asm" "$(NEWLIB_DIRECTORY)/math/integer/*.asm"
NEWLIBZXNGLOBS := "$(NEWLIB_DIRECTORY)/math/integer/z80_zxn/*.asm" 
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80-zxn obj/newlib-r2k obj/newlib-ixiy

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS) $(OUTPUT_DIRECTORY)/fastmath.lib $(OUTPUT_DIRECTORY)/fastmath_ixiy.lib

obj/newlib-z80:  
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-r2k:  
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2k -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-z80-zxn:  
	@$(ASSEMBLER) -d -O=obj/z80-zxn/x -I.. -mz80-zxn -D__CLASSIC $(NEWLIBGLOBS)
	@$(ASSEMBLER) -d -O=obj/z80-zxn/x -I.. -mz80-zxn -D__CLASSIC $(NEWLIBZXNGLOBS)

obj/newlib-ixiy:  
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 --IXIY -D__CLASSIC $(NEWLIBGLOBS)

$(OUTPUT_DIRECTORY)/fastmath.lib: fastmath.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/fastmath.lib @fastmath.lst

$(OUTPUT_DIRECTORY)/fastmath_ixiy.lib: fastmath.lst
	TYPE=ixiy $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/fastmath_ixiy.lib @fastmath.lst

dirs:
	@mkdir -p obj/z80 obj/z80-zxn obj/ixiy obj/r2k


clean:
	$(RM) -fr obj 
