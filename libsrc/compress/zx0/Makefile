#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../../Make.config

TARGET ?= test

NEWLIB := "$(NEWLIB_DIRECTORY)/compress/zx0/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx0/z80/asm*.asm"
NEWLIB_8080 := "$(NEWLIB_DIRECTORY)/compress/zx0/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx0/8080/asm*.asm"
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n obj/newlib-r2k obj/newlib-ixiy  obj/newlib-8080

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80:  
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIB)

obj/newlib-r2k:  
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2ka -D__CLASSIC $(NEWLIB)

obj/newlib-z80n:  
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIB)

obj/newlib-ixiy:  
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(NEWLIB)

obj/newlib-8080:  
	@$(ASSEMBLER) -d -O=obj/8080/x -I.. -m8080 -D__CLASSIC $(NEWLIB_8080)

obj/newlib-gbz80:  
	@$(ASSEMBLER) -d -O=obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(NEWLIB)

dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k obj/8080 obj/gbz80


clean:
	$(RM) -fr obj 
