
include ../../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/font/fzx/zx/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/display/z80/*.asm"
NEWLIB_TARGETS := obj/newlib-z80  obj/newlib-z80n

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80:  
	@$(ASSEMBLER) -d -O=obj/z80/x -I$(NEWLIB_DIRECTORY) -I../../.. -I$(Z88DK_LIBSRC)/classic -mz80 -D__CLASSIC -D__SCCZ80 $(NEWLIBGLOBS)

obj/newlib-z80n:  
	@$(ASSEMBLER) -d -O=obj/z80n/x -I$(NEWLIB_DIRECTORY) -I../../.. -I$(Z88DK_LIBSRC)/classic -mz80n -D__CLASSIC -D__SCCZ80 $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k


clean:
	$(RM) -fr obj 
