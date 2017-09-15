#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../Make.config

TARGET ?= test
CLASSIC_ASM = memopd.asm memopd_callee.asm memopi.asm memopi_callee.asm memops.asm strrstr.asm strrstr_callee.asm $(wildcard _*.asm)
ASMFILES = $(wildcard $(NEWLIB_DIRECTORY)/string/z80/*.asm) $(wildcard $(NEWLIB_DIRECTORY)/string/c/sccz80/*.asm) $(CLASSIC_ASM)

OBJECTS = $(GENOBJECTS) $(CUSTOBJECTS) $(ASMFILES:.asm=.o)

.PHONY: dirs

all: dirs $(addprefix obj/z80/, $(notdir $(OBJECTS))) $(addprefix obj/r2k/,$(notdir $(OBJECTS))) $(addprefix obj/ixiy/,$(notdir $(OBJECTS)))

obj/z80/%.o: %.c
	zcc +$(TARGET) $(CFLAGS) -o @  $^

obj/z80/%.o: $(NEWLIB_DIRECTORY)/string/z80/%.asm
	zcc +$(TARGET) -Ca-DCLASSIC -Ca-I../ $(CFLAGS) -o $@  $^

obj/z80/%.o: $(NEWLIB_DIRECTORY)/string/c/sccz80/%.asm
	zcc +$(TARGET) -Ca-DCLASSIC -Ca-I../ $(CFLAGS) -o $@  $^

obj/z80/%.o: %.asm
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

obj/ixiy/%.o: %.c
	zcc +$(TARGET) -Ca--IXIY $(CFLAGS) -o $@  $^

obj/ixiy/%.o: $(NEWLIB_DIRECTORY)/string/z80/%.asm
	zcc +$(TARGET) -Ca-DCLASSIC -Ca-I../ -Ca--IXIY $(CFLAGS) -o $@  $^

obj/ixiy/%.o: $(NEWLIB_DIRECTORY)/string/c/sccz80/%.asm
	zcc +$(TARGET) -Ca-DCLASSIC -Ca-I../ -Ca--IXIY $(CFLAGS) -o $@  $^

obj/ixiy/%.o: %.asm
	zcc +$(TARGET) -Ca-DCLASSIC -Ca-I../ -Ca--IXIY $(CFLAGS) -o $@  $^

obj/r2k/%.o: %.c
	zcc +rcmx000 $(CFLAGS) -o $@  $^

obj/r2k/%.o: $(NEWLIB_DIRECTORY)/string/z80/%.asm
	zcc +rcmx000 $(CFLAGS) -Ca-DCLASSIC -Ca-I../ -Ca-DFORrcmx000 -o $@  $^

obj/r2k/%.o: $(NEWLIB_DIRECTORY)/string/c/sccz80/%.asm
	zcc +rcmx000 -Ca-DCLASSIC -Ca-I../ $(CFLAGS) -Ca-DFORrcmx000 -o $@  $^

obj/r2k/%.o: %.asm
	zcc +rcmx000 $(CFLAGS) -Ca-DFORrcmx000 -o $@  $^

dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy


clean:
	$(RM) -fr obj
