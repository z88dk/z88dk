#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/sound/ay/c/sccz80/wyz/*.asm" "$(NEWLIB_DIRECTORY)/sound/ay/z80/wyz/*.asm"
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n obj/newlib-r2ka obj/newlib-ixiy 

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80:  
	$(Q)$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-r2ka:  
	$(Q)$(ASSEMBLER) -d -O=obj/r2ka/x -I.. -mr2ka -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-z80n:  
	$(Q)$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-ixiy:  
	$(Q)$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-8080:  
	$(Q)$(ASSEMBLER) -d -O=obj/8080/x -I.. -m8080 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-gbz80:  
	$(Q)$(ASSEMBLER) -d -O=obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2ka obj/8080 obj/gbz80


clean:
	$(RM) -fr obj 
