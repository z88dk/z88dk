#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../Make.config

TARGET ?= test


NEWLIBASM := $(wildcard $(NEWLIB_DIRECTORY)/ctype/c/sccz80/*.asm) $(wildcard $(NEWLIB_DIRECTORY)/ctype/z80/*.asm)
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80-zxn obj/newlib-r2k obj/newlib-ixiy


OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs 

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80: $(NEWLIBASM)
	@$(ASSEMBLER) -O=obj/z80/x -I.. --cpu=z80 -D__CLASSIC $^
	@touch $@

obj/newlib-r2k: $(NEWLIBASM)
	@$(ASSEMBLER) -O=obj/r2k/x -I.. --cpu=r2k -D__CLASSIC $^
	@touch $@

obj/newlib-z80-zxn: $(NEWLIBASM)
	@$(ASSEMBLER) -O=obj/z80-zxn/x -I.. --cpu=z80-zxn -D__CLASSIC $^
	@touch $@

obj/newlib-ixiy: $(NEWLIBASM)
	@$(ASSEMBLER) -O=obj/ixiy/x -I.. --cpu=z80 --IXIY -D__CLASSIC $^
	@touch $@

dirs:
	@mkdir -p obj/z80 obj/z80-zxn obj/ixiy obj/r2k


clean:
	$(RM) -fr obj
