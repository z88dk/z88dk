#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../Make.config

TARGET ?= test

CLASSIC_ASM = memopd.asm memopd_callee.asm memopi.asm memopi_callee.asm memops.asm $(wildcard _*.asm)
CLASSIC_OBJ = $(CLASSIC_ASM:.asm=.o)
CLASSIC_OBJECTS = $(addprefix obj/z80/, $(CLASSIC_OBJ)) $(addprefix obj/z80-zxn/, $(CLASSIC_OBJ)) $(addprefix obj/r2k/, $(CLASSIC_OBJ)) $(addprefix obj/ixiy/, $(CLASSIC_OBJ)) $(addprefix obj/8080/, $(CLASSIC_OBJ))

NEWLIBGLOBS :=  "$(NEWLIB_DIRECTORY)/string/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/string/z80/*.asm"
NEWLIB_PHONY := newlib-z80 newlib-z80-zxn newlib-r2k newlib-ixiy newlib-8080


OBJECTS = $(CLASSIC_OBJECTS) $(NEWLIB_OBJECTS)

.PHONY: dirs $(NEWLIB_PHONY)

all: dirs $(OBJECTS) $(NEWLIB_PHONY)

newlib-z80: 
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

newlib-r2k: 
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2k -D__CLASSIC $(NEWLIBGLOBS)

newlib-z80-zxn: 
	@$(ASSEMBLER) -d -O=obj/z80-zxn/x -I.. -mz80-zxn -D__CLASSIC $(NEWLIBGLOBS)

newlib-ixiy: 
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 --IXIY -D__CLASSIC $(NEWLIBGLOBS)

newlib-8080: 
	@$(ASSEMBLER) -d -O=obj/8080/x -I.. -m8080 --IXIY -D__CLASSIC $(NEWLIBGLOBS)


dirs:
	@mkdir -p obj/z80 obj/z80-zxn obj/ixiy obj/r2k obj/8080


clean:
	$(RM) -fr obj
