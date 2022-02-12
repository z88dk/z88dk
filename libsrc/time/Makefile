#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $


TARGET ?= test

include ../Make.config

GENCFILES = $(wildcard *.c)
GENOBJECTS = $(GENCFILES:.c=.o)
ASMFILES = $(wildcard *.asm)


NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/time/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/time/z80/*.asm" 


NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n obj/newlib-r2k obj/newlib-ixiy obj/newlib-8080 obj/newlib-gbz80

space :=
space +=

OBJECTS = $(GENOBJECTS) $(ASMFILES:.asm=.o)
CLASSIC_OBJECTS = $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) $(addprefix obj/z80n/,$(OBJECTS)) $(addprefix obj/8080/,$(OBJECTS)) $(addprefix obj/gbz80/,$(OBJECTS))


.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(CLASSIC_OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80:
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-r2k:
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2ka -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-z80n:
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-ixiy:
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-8080:
	@$(ASSEMBLER) -d -O=obj/8080/x -I.. -m8080 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-gbz80:
	@$(ASSEMBLER) -d -O=obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/$(TARGET)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(TARGET)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/zxn/%.o: %.c
	$(ZCC) +zxn -clib=classic $(CFLAGS) -o $@ $^


dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k obj/gbz80 -p obj/$(TARGET) obj/newlib-8080 obj/8080 obj/8080/8080 obj/gbz80 obj/gbz80/8080


clean:
	$(RM) -fr obj 
	$(RM) zcc_opt.def
