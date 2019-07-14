#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/ctype/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/ctype/z80/*.asm"
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80-zxn obj/newlib-r2k obj/newlib-ixiy obj/newlib-8080

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80:  
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-r2k:  
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2k -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-z80-zxn:  
	@$(ASSEMBLER) -d -O=obj/z80-zxn/x -I.. -mz80-zxn -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-ixiy:  
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 --IXIY -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-8080:  
	@$(ASSEMBLER) -d -O=obj/8080/x -I.. -m8080 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80 obj/z80-zxn obj/ixiy obj/r2k obj/8080


clean:
	$(RM) -fr obj 
