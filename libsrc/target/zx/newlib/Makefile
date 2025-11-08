include ../../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/target/zx-libs/graphics/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/graphics/c/sccz80/*.asm" 

NEWLIB_TARGETS := obj/newlib-z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80: config_private.inc 
	$(Q)$(ASSEMBLER)  -m4=-I$(Z88DK_LIB)/../src/m4 -d -O=obj/z80/x -I.. -I$(Z88DK_LIB) -I$(Z88DK_LIBSRC)/classic -mz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80


clean:
	$(RM) -fr obj  bifrost*
