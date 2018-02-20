#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../../Make.config

TARGET ?= test

CLASSIC_ASM = $(wildcard *.asm)
CLASSIC_OBJ = $(CLASSIC_ASM:.asm=.o)
CLASSIC_OBJECTS = $(addprefix obj/z80/, $(CLASSIC_OBJ)) $(addprefix obj/z80-zxn/, $(CLASSIC_OBJ)) $(addprefix obj/r2k/, $(CLASSIC_OBJ)) $(addprefix obj/ixiy/, $(CLASSIC_OBJ))

NEWLIBASM := $(wildcard $(NEWLIB_DIRECTORY)/alloc/balloc/c/sccz80/*.asm) $(wildcard $(NEWLIB_DIRECTORY)/alloc/balloc/z80/*.asm)
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80-zxn obj/newlib-r2k obj/newlib-ixiy


OBJECTS = $(CLASSIC_OBJECTS) $(NEWLIB_TARGETS)

.PHONY: dirs

all: dirs $(OBJECTS) 

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


obj/z80/%.o: %.asm
	@$(ASSEMBLER) -I../ --cpu=z80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/ixiy/%.o: %.asm
	@$(ASSEMBLER) -I../ --IXIY --cpu=z80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/r2k/%.o: %.asm
	@$(ASSEMBLER) -I../ --cpu=r2k -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/z80-zxn/%.o: %.asm
	@$(ASSEMBLER) -I../ --cpu=z80-zxn -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/z80/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o   $^

obj/z80-zxn/%.o: %.c
	$(ZCC) +$(TARGET) -mz80-zxn -custom-copt-rules=$(Z88DK_LIB)/zxn_rules.1 $(CFLAGS) -o   $^

obj/ixiy/%.o: %.c
	$(ZCC) +$(TARGET) -Ca--IXIY $(CFLAGS) -o $  $^

obj/r2k/%.o: %.c
	$(ZCC) +rcmx000 $(CFLAGS) -o $  $^

dirs:
	@mkdir -p obj/z80 obj/z80-zxn obj/ixiy obj/r2k


clean:
	$(RM) -fr obj
