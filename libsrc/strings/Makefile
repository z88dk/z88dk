#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../Make.config

TARGET ?= test

CLASSIC_ASM = memopd.asm memopd_callee.asm memopi.asm memopi_callee.asm memops.asm $(wildcard _*.asm)
CLASSIC_OBJ = $(CLASSIC_ASM:.asm=.o)
CLASSIC_OBJECTS = $(addprefix obj/z80/, $(CLASSIC_OBJ)) $(addprefix obj/z80n/, $(CLASSIC_OBJ)) $(addprefix obj/r2k/, $(CLASSIC_OBJ)) $(addprefix obj/ixiy/, $(CLASSIC_OBJ))

NEWLIBGLOBS :=  "$(NEWLIB_DIRECTORY)/string/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/string/z80/*.asm"
NEWLIB_PHONY := newlib-z80 newlib-z80n newlib-r2k newlib-ixiy


OBJECTS = $(CLASSIC_OBJECTS) $(NEWLIB_OBJECTS)

.PHONY: dirs $(NEWLIB_PHONY)

all: dirs $(OBJECTS) $(NEWLIB_PHONY)

newlib-z80: 
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

newlib-r2k: 
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2k -D__CLASSIC $(NEWLIBGLOBS)

newlib-z80n: 
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

newlib-ixiy: 
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 --IXIY -D__CLASSIC $(NEWLIBGLOBS)


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
