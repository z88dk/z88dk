include ../../../Make.config

TARGET ?= test

BIFROST2_GEN = bifrost2_engine_48.bin.zx0 bifrost2_engine_p3.bin.zx0

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/target/zx-libs/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/display/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx-libs/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/misc/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx-libs/graphics/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/graphics/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx-libs/nirvanap/c/sccz80/*.asm" \
	$(NEWLIB_DIRECTORY)/target/zx-libs/nirvanap/z80/asm_NIRVANAP_spriteT.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/nirvanap/z80/asm_NIRVANAP_drawW_di.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/nirvanap/z80/asm_NIRVANAP_fillT_di.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/nirvanap/z80/asm_NIRVANAP_stop.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/nirvanap/z80/NIRVANAP_ENGINE.asm.m4 \
	$(NEWLIB_DIRECTORY)/target/zx-libs/nirvanap/z80/asm_NIRVANAP_drawTW_di.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/nirvanap/z80/asm_NIRVANAP_drawT_di.asm \
	"$(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/c/sccz80/*.asm" $(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/z80/BIFROST2_INSTALL.asm.m4 \
	$(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/z80/asm_BIFROST2_getTile.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/z80/asm_BIFROST2_resetAnim2Frames.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/z80/asm_BIFROST2_setTile.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/z80/asm_BIFROST2_resetAnim4Frames.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/z80/asm_BIFROST2_stop.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/z80/asm_BIFROST2_getAnimGroup.asm \
	$(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/z80/asm_BIFROST2_findAttrH.asm 

NEWLIB_TARGETS := obj/newlib-z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

bifrost2_engine_48.bin.zx0: config_private.inc
	$(Q)$(ASSEMBLER) -m4=-I$(Z88DK_LIB)/../src/m4 -g -I$(Z88DK_LIB) -DSTRIPVECTOR -b -obifrost2_engine_48.bin  $(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/z80/BIFROST2_ENGINE.asm.m4 
	$(ZX0) -f bifrost2_engine_48.bin

bifrost2_engine_p3.bin.zx0: bifrost2_engine_48.bin.zx0 config_private.inc
	$(Q)$(ASSEMBLER) -m4=-I$(Z88DK_LIB)/../src/m4 -g -I$(Z88DK_LIB) -DSTRIPVECTOR -DPLUS3 -b -obifrost2_engine_p3.bin  $(NEWLIB_DIRECTORY)/target/zx-libs/bifrost2/z80/BIFROST2_ENGINE.asm.m4 
	$(ZX0) -f bifrost2_engine_p3.bin

 
obj/newlib-z80: $(BIFROST2_GEN) config_private.inc 
	$(Q)$(ASSEMBLER)  -m4=-I$(Z88DK_LIB)/../src/m4 -d -O=obj/z80/x -I.. -I$(Z88DK_LIB) -I$(Z88DK_LIBSRC)/classic -mz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80


clean:
	$(RM) -fr obj  bifrost*
