#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../Make.config

TARGET ?= test

GENOBJECTS = unbcd.o wcmatch.o getopt.o
CUSTOBJECTS = sleep.o 
ASMFILES = $(wildcard *.asm)


NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/stdlib/z80/*.asm" "$(NEWLIB_DIRECTORY)/stdlib/z80/random/*.asm"
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n obj/newlib-r2k obj/newlib-ixiy

space :=
space +=

OBJECTS = $(GENOBJECTS) $(ASMFILES:.asm=.o)
CLASSIC_OBJECTS = $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS))  $(addprefix obj/$(TARGET)/,$(CUSTOBJECTS))  $(addprefix obj/z80n/,$(OBJECTS))


.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(CLASSIC_OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80:  
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-r2k:  
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2k -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-z80n:  
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-ixiy:  
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 --IXIY -D__CLASSIC $(NEWLIBGLOBS)

obj/$(TARGET)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(TARGET)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^


dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k -p obj/$(TARGET)


clean:
	$(RM) -fr obj 
