include ../../../Make.config

TARGET ?= test

BIFROST2_GEN = bifrost2_engine_48.bin.zx0 bifrost2_engine_p3.bin.zx0

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/arch/zx/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/display/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zx/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/misc/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zx/graphics/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/graphics/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zx/ulaplus/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/ulaplus/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zx/bifrost2/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/bifrost2/c/sccz80/*.asm" $(NEWLIB_DIRECTORY)/arch/zx/bifrost2/z80/BIFROST2_INSTALL.asm.m4 

NEWLIB_TARGETS := obj/newlib-z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

bifrost2_engine_48.bin.zx0:
	$(ZCC) +z80 -vn --no-crt -clib=nolib -g -Ca"-DSTRIPVECTOR"  $(NEWLIB_DIRECTORY)/arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o bifrost2_engine_48.bin
	$(ZX0) -f bifrost2_engine_48.bin

bifrost2_engine_p3.bin.zx0:
	$(ZCC) +z80 -vn --no-crt -clib=nolib -g -Ca"-DPLUS3 -DSTRIPVECTOR"  $(NEWLIB_DIRECTORY)/arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o bifrost2_engine_p3.bin
	$(ZX0) -f bifrost2_engine_p3.bin


obj/newlib-z80: $(BIFROST2_GEN)
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -I$(Z88DK_LIB) -mz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80


clean:
	$(RM) -fr obj  bifrost*
