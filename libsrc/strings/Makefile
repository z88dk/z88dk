#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../Make.config

TARGET ?= test
ASMFILES = $(wildcard *.asm)

OBJECTS = $(GENOBJECTS) $(CUSTOBJECTS) $(ASMFILES:.asm=.o)

.PHONY: dirs

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS))

obj/z80/%.o: %.c
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

obj/z80/%.o: %.asm
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

obj/ixiy/%.o: %.c
	zcc +$(TARGET) -Ca--IXIY $(CFLAGS) -o $@  $^

obj/ixiy/%.o: %.asm
	zcc +$(TARGET) -Ca--IXIY $(CFLAGS) -o $@  $^

obj/r2k/%.o: %.c
	zcc +rcmx000 $(CFLAGS) -o $@  $^

obj/r2k/%.o: %.asm
	zcc +rcmx000 $(CFLAGS) -Ca-DFORrcmx000 -o $@  $^

dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy


clean:
	$(RM) -fr obj
