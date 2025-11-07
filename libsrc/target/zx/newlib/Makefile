include ../../../Make.config

TARGET ?= test

BIFROST2_GEN = bifrost2_engine_48.bin.zx0 bifrost2_engine_p3.bin.zx0

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/target/zx-libs/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/display/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx-libs/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/misc/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx-libs/graphics/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/graphics/c/sccz80/*.asm" 

NEWLIB_TARGETS := obj/newlib-z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80: $(BIFROST2_GEN) config_private.inc 
	$(Q)$(ASSEMBLER)  -m4=-I$(Z88DK_LIB)/../src/m4 -d -O=obj/z80/x -I.. -I$(Z88DK_LIB) -I$(Z88DK_LIBSRC)/classic -mz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80


clean:
	$(RM) -fr obj  bifrost*
