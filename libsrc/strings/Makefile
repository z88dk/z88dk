#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../Make.config

TARGET ?= test

CLASSIC_ASM = memopd.asm memopd_callee.asm memopi.asm memopi_callee.asm memops.asm strrstr.asm strrstr_callee.asm $(wildcard _*.asm)
CLASSIC_OBJ = $(CLASSIC_ASM:.asm=.o)
CLASSIC_OBJECTS = $(addprefix obj/z80/, $(CLASSIC_OBJ)) $(addprefix obj/z80-zxn/, $(CLASSIC_OBJ)) $(addprefix obj/r2k/, $(CLASSIC_OBJ)) $(addprefix obj/ixiy/, $(CLASSIC_OBJ))

NEWLIBASM := $(shell z88dk-lstmanip -i $(NEWLIB_DIRECTORY)/string/string_sccz80.lst -p $(NEWLIB_DIRECTORY) -t)
NEWLIBOBJ := $(NEWLIBASM:.asm=.o)
NEWLIB_OBJECTS := $(subst $(NEWLIB_DIRECTORY),obj/z80,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/z80-zxn,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/r2k,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/ixiy,$(NEWLIBOBJ))

OBJECTS = $(CLASSIC_OBJECTS) $(NEWLIB_OBJECTS)

.PHONY: dirs

all: dirs $(OBJECTS) string-newlib.lst

obj/z80/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --cpu=z80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/ixiy/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --IXIY --cpu=z80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/r2k/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --cpu=r2k -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/z80-zxn/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --cpu=z80-zxn -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

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
	zcc +$(TARGET) $(CFLAGS) -o   $^

obj/z80-zxn/%.o: %.c
	zcc +$(TARGET) -mz80-zxn -custom-copt-rules=$(Z88DK_LIB)/zxn_rules.1 $(CFLAGS) -o   $^

obj/ixiy/%.o: %.c
	zcc +$(TARGET) -Ca--IXIY $(CFLAGS) -o $  $^

obj/r2k/%.o: %.c
	zcc +rcmx000 $(CFLAGS) -o $  $^

string-newlib.lst:
	@z88dk-lstmanip -i $(NEWLIB_DIRECTORY)/string/string_sccz80.lst -p $(NEWLIB_DIRECTORY) -c -o string-newlib.lst

dirs:
	@mkdir -p $(dir $(OBJECTS))


clean:
	$(RM) -fr obj string-newlib.lst
