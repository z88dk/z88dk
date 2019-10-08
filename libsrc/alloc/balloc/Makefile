#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../../Make.config

TARGET ?= test

CLASSIC_ASM = $(wildcard *.asm)
CLASSIC_OBJ = $(CLASSIC_ASM:.asm=.o)
CLASSIC_OBJECTS = $(addprefix obj/z80/, $(CLASSIC_OBJ)) $(addprefix obj/z80n/, $(CLASSIC_OBJ)) $(addprefix obj/r2k/, $(CLASSIC_OBJ)) $(addprefix obj/ixiy/, $(CLASSIC_OBJ))

NEWLIBASM := $(wildcard $(NEWLIB_DIRECTORY)/alloc/balloc/c/sccz80/*.asm) $(wildcard $(NEWLIB_DIRECTORY)/alloc/balloc/z80/*.asm)
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n obj/newlib-r2k obj/newlib-ixiy


OBJECTS = $(CLASSIC_OBJECTS) $(NEWLIB_TARGETS)

.PHONY: dirs

all: dirs $(OBJECTS) 

obj/newlib-z80: $(NEWLIBASM)
	@$(ASSEMBLER) -O=obj/z80/x -I.. -mz80 -D__CLASSIC $^
	@touch $@

obj/newlib-r2k: $(NEWLIBASM)
	@$(ASSEMBLER) -O=obj/r2k/x -I.. -mr2k -D__CLASSIC $^
	@touch $@

obj/newlib-z80n: $(NEWLIBASM)
	@$(ASSEMBLER) -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $^
	@touch $@

obj/newlib-ixiy: $(NEWLIBASM)
	@$(ASSEMBLER) -O=obj/ixiy/x -I.. -mz80 --IXIY -D__CLASSIC $^
	@touch $@


obj/z80/%.o: %.asm
	@$(ASSEMBLER) -I../ -mz80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/ixiy/%.o: %.asm
	@$(ASSEMBLER) -I../ --IXIY -mz80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/r2k/%.o: %.asm
	@$(ASSEMBLER) -I../ -mr2k -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/z80n/%.o: %.asm
	@$(ASSEMBLER) -I../ -mz80n -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/z80/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o   $^

obj/z80n/%.o: %.c
	$(ZCC) +$(TARGET) -mz80n -custom-copt-rules=$(Z88DK_LIB)/z80n_rules.1 $(CFLAGS) -o   $^

obj/ixiy/%.o: %.c
	$(ZCC) +$(TARGET) -Ca--IXIY $(CFLAGS) -o $  $^

obj/r2k/%.o: %.c
	$(ZCC) +rcmx000 $(CFLAGS) -o $  $^

dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k


clean:
	$(RM) -fr obj
