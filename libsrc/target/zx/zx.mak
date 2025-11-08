ZX_GLOBS := "$(Z88DK_LIBSRC)/target/zx/ulaplus/c/sccz80/*.asm" "$(Z88DK_LIBSRC)/target/zx/ulaplus/z80/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/ulaplus/c/smallc/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/display/c/sccz80/*.asm" "$(Z88DK_LIBSRC)/target/zx/display/z80/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/misc/c/sccz80/*.asm" "$(Z88DK_LIBSRC)/target/zx/misc/z80/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/diagnostic/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/basic/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/opus/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/specdrum/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/uspeech/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/psg/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/games/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/input/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/if1/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/zxmmc/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/misc/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/stdio/*.asm"\
	"$(Z88DK_LIBSRC)/target/zx/classic/graphics/*.asm" 

MULTICOLOUR_GLOBS := "$(Z88DK_LIBSRC)/target/zx/bifrost2/c/sccz80/*.asm" $(Z88DK_LIBSRC)/target/zx/bifrost2/z80/BIFROST2_INSTALL.asm.m4 \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_getTile.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_resetAnim2Frames.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_setTile.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_resetAnim4Frames.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_stop.asm \
        $(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_getAnimGroup.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_findAttrH.asm \
	"$(NEWLIB_DIRECTORY)/target/zx/bifrost_h/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx/bifrost_h/z80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx/bifrost_l/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx/bifrost_l/z80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx/nirvanap/c/sccz80/*.asm" \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_spriteT.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_drawW_di.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_fillT_di.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_stop.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/NIRVANAP_ENGINE.asm.m4 \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_drawTW_di.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_drawT_di.asm

ZX_GLOBS_ex := $(Z88DK_LIBSRC)/target/zx/ulaplus/c/sccz80/*.asm $(Z88DK_LIBSRC)/target/zx/ulaplus/z80/*.asm \
	$(Z88DK_LIBSRC)/target/zx/ulaplus/c/smallc/*.asm \
	$(Z88DK_LIBSRC)/target/zx/display/c/sccz80/*.asm $(Z88DK_LIBSRC)/target/zx/display/z80/*.asm \
	$(Z88DK_LIBSRC)/target/zx/misc/c/sccz80/*.asm $(Z88DK_LIBSRC)/target/zx/misc/z80/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/diagnostic/*.asm \
        $(Z88DK_LIBSRC)/target/zx/classic/basic/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/opus/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/specdrum/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/uspeech/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/games/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/psg/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/input/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/if1/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/zxmmc/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/misc/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/stdio/*.asm  \
	$(Z88DK_LIBSRC)/target/zx/classic/graphics/*.asm

MULTICOLOUR_GLOBS_ex := $(Z88DK_LIBSRC)/target/zx/bifrost2/c/sccz80/*.asm $(Z88DK_LIBSRC)/target/zx/bifrost2/z80/BIFROST2_INSTALL.asm.m4 \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_getTile.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_resetAnim2Frames.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_setTile.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_resetAnim4Frames.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_stop.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_getAnimGroup.asm \
	$(Z88DK_LIBSRC)/target/zx/bifrost2/z80/asm_BIFROST2_findAttrH.asm \
	$(NEWLIB_DIRECTORY)/target/zx/bifrost_h/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/target/zx/bifrost_h/z80/*.asm \
	$(NEWLIB_DIRECTORY)/target/zx/bifrost_l/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/target/zx/bifrost_l/z80/*.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/c/sccz80/*.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_spriteT.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_drawW_di.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_fillT_di.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_stop.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/NIRVANAP_ENGINE.asm.m4 \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_drawTW_di.asm \
	$(NEWLIB_DIRECTORY)/target/zx/nirvanap/z80/asm_NIRVANAP_drawT_di.asm

ZX_CFILES = target/zx/tape/tape_save.c

ZX_OFILES = $(addprefix target/zx/obj/zx/, $(ZX_CFILES:.c=.o)) \
	$(addprefix target/zx/obj/zxn/, $(ZX_CFILES:.c=.o)) \
	$(addprefix target/zx/obj/ts2068/, $(ZX_CFILES:.c=.o)) 


BIFROST2_GEN = bifrost2_engine_48.bin.zx0 bifrost2_engine_p3.bin.zx0


ZX_TARGETS := target/zx/obj/target-zx-zx \
	target/zx/obj/target-zx-zxn \
	target/zx/obj/target-zx-ts2068 \
	$(ZX_OFILES)
		

CLEAN += target-zx-clean

target-zx: $(ZX_TARGETS)

.PHONY: target-zx target-zx-clean

# Arg1: machine
define bifrost_zx0
target/zx/obj/$(1)/bifrost2_engine_48.bin.zx0: 
	@mkdir -p target/zx/obj/$(1)
	$(Q)$(ASSEMBLER) -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I$(Z88DK_LIBSRC)/target/$(1) -g -I$(Z88DK_LIB) -DSTRIPVECTOR -b -o$$(@:.zx0=) target/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4
	$(ZX0) -f $$(@:.zx0=)

target/zx/obj/$(1)/bifrost2_engine_p3.bin.zx0: target/zx/obj/$(1)/bifrost2_engine_48.bin.zx0 
	$(Q)$(ASSEMBLER) -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I$(Z88DK_LIBSRC)/target/$(1) -g -I$(Z88DK_LIB) -DSTRIPVECTOR -DPLUS3 -b -o$$(@:.zx0=) target/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4
	$(ZX0) -f $$(@:.zx0=)
endef


$(eval $(call buildtargetasm,target/zx,z80,zx,-mz80,$(ZX_GLOBS) $(MULTICOLOUR_GLOBS),$(ZX_GLOBS_ex) $(BIFROST2_DEPS_ex) $(addprefix target/zx/obj/zx/, $(BIFROST2_GEN))))
$(eval $(call buildtargetasm,target/zx,z80n,zxn,-mz80n,$(ZX_GLOBS) $(MULTICOLOUR_GLOBS),$(ZX_GLOBS_ex) $(MULTICOLOUR_GLOBS_ex) $(addprefix target/zx/obj/zxn/, $(BIFROST2_GEN))))
$(eval $(call buildtargetc,target/zx,zx))
$(eval $(call buildtargetc,target/zx,zxn,-clib=classic))
$(eval $(call bifrost_zx0,zx))
$(eval $(call bifrost_zx0,zxn))

target-zx-clean:
	$(RM) -fr target/zx/obj
