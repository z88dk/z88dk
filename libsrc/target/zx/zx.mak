ZX_GLOBS := "target/zx/ulaplus/c/sccz80/*.asm" "target/zx/ulaplus/z80/*.asm" \
	"target/zx/ulaplus/c/smallc/*.asm" \
	"target/zx/display/c/sccz80/*.asm" "target/zx/display/z80/*.asm" \
	"target/zx/graphics/c/sccz80/*.asm" "target/zx/graphics/z80/*.asm" \
	"target/zx/esxdos/c/sccz80/*.asm" "target/zx/esxdos/z80/*.asm" \
	"target/zx/misc/c/sccz80/*.asm" "target/zx/misc/z80/*.asm" \
	"target/zx/tape/c/sccz80/*.asm" "target/zx/tape/z80/*.asm" "target/zx/tape/c/smallc/*.asm" \
	"target/zx/sound/ay/*.asm" \
	"target/zx/classic/diagnostic/*.asm" \
	"target/zx/classic/basic/*.asm" \
	"target/zx/classic/opus/*.asm" \
	"target/zx/classic/specdrum/*.asm" \
	"target/zx/classic/uspeech/*.asm" \
	"target/zx/classic/psg/*.asm" \
	"target/zx/classic/games/*.asm" \
	"target/zx/classic/input/*.asm" \
	"target/zx/classic/if1/*.asm" \
	"target/zx/classic/zxmmc/*.asm" \
	"target/zx/classic/misc/*.asm" \
	"target/zx/classic/stdio/*.asm"\
	"target/zx/classic/stdio/ansi/*.asm" \
	"target/zx/classic/graphics/*.asm" \
	"target/shared/clock.asm"

ZX_GLOBS_ex := target/zx/ulaplus/c/sccz80/*.asm target/zx/ulaplus/z80/*.asm \
	target/zx/ulaplus/c/smallc/*.asm \
	target/zx/display/c/sccz80/*.asm target/zx/display/z80/*.asm \
	target/zx/esxdos/c/sccz80/*.asm target/zx/esxdos/z80/*.asm \
	target/zx/misc/c/sccz80/*.asm target/zx/misc/z80/*.asm \
	target/zx/tape/c/sccz80/*.asm target/zx/tape/z80/*.asm target/zx/tape/c/smallc/*.asm \
	target/zx/sound/ay/*.asm \
	target/zx/classic/diagnostic/*.asm \
	target/zx/classic/basic/*.asm \
	target/zx/classic/opus/*.asm \
	target/zx/classic/specdrum/*.asm \
	target/zx/classic/uspeech/*.asm \
	target/zx/classic/games/*.asm \
	target/zx/classic/psg/*.asm \
	target/zx/classic/input/*.asm \
	target/zx/classic/if1/*.asm \
	target/zx/classic/zxmmc/*.asm \
	target/zx/classic/misc/*.asm \
	target/zx/classic/stdio/*.asm  \
	target/zx/classic/stdio/ansi/*.asm \
	target/zx/classic/graphics/*.asm \
	target/shared/clock.asm


# These shouldn't be shared with ZXN
ZX_ONLY_GLOBS = \
	"target/zx/far/*.asm" \
	"target/zx/classic/far/*.asm" \
	"target/zx/esxdos/c/sccz80/*.asm" "target/zx/esxdos/z80/*.asm"

ZX_ONLY_GLOBS_ex = \
	target/zx/far/*.asm \
	target/zx/classic/far/*.asm \
	target/zx/esxdos/c/sccz80/*.asm target/zx/esxdos/z80/*.asm

ZXCPM_GLOBS := \
	"target/zx/display/c/sccz80/*.asm" "target/zx/display/z80/*.asm" \
	"target/zx/graphics/c/sccz80/*.asm" "target/zx/graphics/z80/*.asm" \
	"target/zx/misc/c/sccz80/*.asm" "target/zx/misc/z80/*.asm" \
	"target/zx/classic/cpm/*.asm" \
	"target/zx/classic/graphics_cpm/*.asm" \
	"target/zx/classic/games/*.asm" 

ZXCPM_GLOBS_ex := \
	target/zx/display/c/sccz80/*.asm target/zx/display/z80/*.asm \
	target/zx/graphics/c/sccz80/*.asm target/zx/graphics/z80/*.asm \
	target/zx/misc/c/sccz80/*.asm target/zx/misc/z80/*.asm \
	target/zx/classic/cpm/*.asm \
	target/zx/classic/graphics_cpm/*.asm \
	target/zx/classic/games/*.asm 
	

ZX_MULTICOLOUR_GLOBS := "target/zx/bifrost2/c/sccz80/*.asm" target/zx/bifrost2/z80/BIFROST2_INSTALL.asm.m4 \
	target/zx/bifrost2/z80/asm_BIFROST2_getTile.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_resetAnim2Frames.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_setTile.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_resetAnim4Frames.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_stop.asm \
        target/zx/bifrost2/z80/asm_BIFROST2_getAnimGroup.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_findAttrH.asm \
	"target/zx/bifrost_h/c/sccz80/*.asm" "target/zx/bifrost_h/z80/*.asm" \
	"target/zx/bifrost_l/c/sccz80/*.asm" "target/zx/bifrost_l/z80/*.asm" \
	"target/zx/nirvanap/c/sccz80/*.asm" \
	target/zx/nirvanap/z80/asm_NIRVANAP_spriteT.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_drawW_di.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_fillT_di.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_stop.asm \
	target/zx/nirvanap/z80/NIRVANAP_ENGINE.asm.m4 \
	target/zx/nirvanap/z80/asm_NIRVANAP_drawTW_di.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_drawT_di.asm


ZX_MULTICOLOUR_GLOBS_ex := target/zx/bifrost2/c/sccz80/*.asm target/zx/bifrost2/z80/BIFROST2_INSTALL.asm.m4 \
	target/zx/bifrost2/z80/asm_BIFROST2_getTile.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_resetAnim2Frames.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_setTile.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_resetAnim4Frames.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_stop.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_getAnimGroup.asm \
	target/zx/bifrost2/z80/asm_BIFROST2_findAttrH.asm \
	target/zx/bifrost_h/c/sccz80/*.asm target/zx/bifrost_h/z80/*.asm \
	target/zx/bifrost_l/c/sccz80/*.asm target/zx/bifrost_l/z80/*.asm \
	target/zx/nirvanap/c/sccz80/*.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_spriteT.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_drawW_di.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_fillT_di.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_stop.asm \
	target/zx/nirvanap/z80/NIRVANAP_ENGINE.asm.m4 \
	target/zx/nirvanap/z80/asm_NIRVANAP_drawTW_di.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_drawT_di.asm

ZX_CFILES = target/zx/tape/tape_save.c

ZX_OFILES = $(addprefix target/zx/obj/zx/, $(ZX_CFILES:.c=.o)) 


BIFROST2_GEN = bifrost2_engine_48.bin.zx0 bifrost2_engine_p3.bin.zx0


ZX_TARGETS := target/zx/obj/target-zx-zx $(ZX_OFILES) target/zx/obj/target-zx-zxcpm
		

CLEAN += target-zx-clean

target-zx: $(ZX_TARGETS)

.PHONY: target-zx target-zx-clean

# Arg1: machine
define bifrost_zx0
target/$(1)/obj/$(1)/bifrost2_engine_48.bin.zx0: 
	@mkdir -p target/$(1)/obj/$(1)
	$(Q)$(ASSEMBLER) -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-Itarget/$(1) -g -I$(Z88DK_LIB) -DSTRIPVECTOR -b -o$$(@:.zx0=) target/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4
	$(ZX0) -f $$(@:.zx0=)

target/$(1)/obj/$(1)/bifrost2_engine_p3.bin.zx0: target/$(1)/obj/$(1)/bifrost2_engine_48.bin.zx0 
	$(Q)$(ASSEMBLER) -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-Itarget/$(1) -g -I$(Z88DK_LIB) -DSTRIPVECTOR -DPLUS3 -b -o$$(@:.zx0=) target/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4
	$(ZX0) -f $$(@:.zx0=)
endef


$(eval $(call buildtargetasm,target/zx,z80,zx,-mz80,$(ZX_GLOBS) $(ZX_ONLY_GLOBS) $(ZX_MULTICOLOUR_GLOBS),$(ZX_GLOBS_ex) $(ZX_ONLY_GLOBS_ex) $(BIFROST2_DEPS_ex) $(addprefix target/zx/obj/zx/, $(BIFROST2_GEN))))
$(eval $(call buildtargetc,target/zx,zx))
$(eval $(call bifrost_zx0,zx))

$(eval $(call buildtargetasm,target/zx,z80,zxcpm,-mz80,$(ZXCPM_GLOBS),$(ZXCPM_GLOBS_ex)))

target-zx-clean:
	$(RM) -fr target/zx/obj
