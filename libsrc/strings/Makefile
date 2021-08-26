#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../Make.config

TARGET ?= test

CLASSIC_ASM = memopd.asm memopd_callee.asm memopi.asm memopi_callee.asm memops.asm $(wildcard _*.asm)
CLASSIC_OBJ = $(CLASSIC_ASM:.asm=.o)

CLASSIC_ASM_8080 = $(wildcard _*.asm)
CLASSIC_OBJ_8080 = $(CLASSIC_ASM_8080:.asm=.o)

CLASSIC_ASM_GBZ80 = $(wildcard _*.asm)
CLASSIC_OBJ_GBZ80 = $(CLASSIC_ASM_GB80:.asm=.o)

CLASSIC_OBJECTS = $(addprefix obj/z80/, $(CLASSIC_OBJ)) $(addprefix obj/z80n/, $(CLASSIC_OBJ)) $(addprefix obj/r2k/, $(CLASSIC_OBJ)) $(addprefix obj/ixiy/, $(CLASSIC_OBJ)) $(addprefix obj/8080/, $(CLASSIC_OBJ_8080)) $(addprefix obj/gbz80/, $(CLASSIC_OBJ_GBZ80))

NEWLIBGLOBS :=  "$(NEWLIB_DIRECTORY)/string/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/string/z80/*.asm"
NEWLIB_PHONY := newlib-z80 newlib-z80n newlib-r2k newlib-ixiy newlib-8080 newlib-gbz80


OBJECTS = $(CLASSIC_OBJECTS) $(NEWLIB_OBJECTS)

.PHONY: dirs $(NEWLIB_PHONY)

all: dirs $(OBJECTS) $(NEWLIB_PHONY)

newlib-z80: 
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

newlib-r2k: 
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2ka -D__CLASSIC $(NEWLIBGLOBS)

newlib-z80n: 
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

newlib-ixiy: 
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(NEWLIBGLOBS)

newlib-8080: 
	@$(ASSEMBLER) -d -O=obj/8080/x -I.. -m8080 -IXIY -D__CLASSIC $(NEWLIBGLOBS)

newlib-gbz80: 
	@$(ASSEMBLER) -d -O=obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(NEWLIBGLOBS)


dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k obj/8080 obj/gbz80


clean:
	$(RM) -fr obj
