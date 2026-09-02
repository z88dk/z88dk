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
	"target/zx/bifrost_h/c/sccz80/*.asm" \
	target/zx/bifrost_h/z80/BIFROSTH_ENGINE.asm.m4 \
	target/zx/bifrost_h/z80/asm_BIFROSTH_findAttrH.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_getAnimGroup.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_getTile.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_resetAnim2Frames.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_resetAnim4Frames.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_setTile.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_stop.asm \
	"target/zx/bifrost_l/c/sccz80/*.asm" \
	target/zx/bifrost_l/z80/BIFROSTL_ENGINE.asm.m4 \
	target/zx/bifrost_l/z80/asm_BIFROSTL_findAttrH.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_getAnimGroup.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_getTile.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_resetAnim2Frames.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_resetAnim4Frames.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_setTile.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_stop.asm \
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
	target/zx/bifrost_h/c/sccz80/*.asm \
	target/zx/bifrost_h/z80/BIFROSTH_ENGINE.asm.m4 \
	target/zx/bifrost_h/z80/asm_BIFROSTH_findAttrH.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_getAnimGroup.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_getTile.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_resetAnim2Frames.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_resetAnim4Frames.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_setTile.asm \
	target/zx/bifrost_h/z80/asm_BIFROSTH_stop.asm \
	target/zx/bifrost_l/c/sccz80/*.asm \
	target/zx/bifrost_l/z80/BIFROSTL_ENGINE.asm.m4 \
	target/zx/bifrost_l/z80/asm_BIFROSTL_findAttrH.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_getAnimGroup.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_getTile.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_resetAnim2Frames.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_resetAnim4Frames.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_setTile.asm \
	target/zx/bifrost_l/z80/asm_BIFROSTL_stop.asm \
	target/zx/nirvanap/c/sccz80/*.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_spriteT.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_drawW_di.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_fillT_di.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_stop.asm \
	target/zx/nirvanap/z80/NIRVANAP_ENGINE.asm.m4 \
	target/zx/nirvanap/z80/asm_NIRVANAP_drawTW_di.asm \
	target/zx/nirvanap/z80/asm_NIRVANAP_drawT_di.asm

ZX_CFILES = target/zx/tape/tape_save.c

ZX_OFILES = $(patsubst target/zx/%,target/zx/obj/zx/%,$(ZX_CFILES:.c=.o))


BIFROST2_GEN = bifrost2_engine_48.bin.zx0 bifrost2_engine_p3.bin.zx0


ZX_TARGETS := target/zx/obj/target-zx-zx $(ZX_OFILES) target/zx/obj/target-zx-zxcpm classic/games/obj/.stamp-zx classic/gfx/obj/.stamp-zx-narrow

$(eval $(call gfx_stamp,zx,narrow))
		

CLEAN += target-zx-clean
mzx.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/zxmath mzx

mzx_tiny.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Tiny Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/zxmath mzx_tiny


target-zx: $(ZX_TARGETS)

.PHONY: target-zx target-zx-clean

# Arg1: machine
define bifrost_zx0
target/$(1)/obj/$(1)/bifrost2_engine_48.bin.zx0: 
	$(Q)mkdir -p target/$(1)/obj/$(1)
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

# ZX support libraries
define zx_support
ZX_$(1)_CFILES := $(wildcard target/zx/classic/$(2)/*.c)
ZX_$(1)_ASMFILES := $(wildcard target/zx/classic/$(2)/*.asm)
ZX_$(1)_C_OBJECTS := $$(patsubst target/zx/%,target/zx/obj/support/%,$$(ZX_$(1)_CFILES:.c=.o))
ZX_$(1)_ASM_OBJECTS := $$(patsubst target/zx/%,target/zx/obj/support/%,$$(ZX_$(1)_ASMFILES:.asm=.o))
ZX_$(1)_OBJECTS := $$(ZX_$(1)_C_OBJECTS) $$(ZX_$(1)_ASM_OBJECTS)

$$(ZX_$(1)_C_OBJECTS): target/zx/obj/support/classic/$(2)/%.o: target/zx/classic/$(2)/%.c
	$(Q)mkdir -p $$(dir $$@)
	$$(ZCC) +zx $$(CFLAGS) $(3) -c -o $$@ $$<

$$(ZX_$(1)_ASM_OBJECTS): target/zx/obj/support/classic/$(2)/%.o: target/zx/classic/$(2)/%.asm
	$(Q)mkdir -p $$(dir $$@)
	$$(ZCC) +zx $$(CFLAGS) $(3) -c -o $$@ $$<
endef

$(eval $(call zx_support,microdrive,fcntl/microdrive))
$(eval $(call zx_support,plus3,fcntl/plus3,-DPLUS3))
$(eval $(call zx_support,zxbasdrv,fcntl/zxbasdrv))
$(eval $(call zx_support,esxdos,fcntl/esxdos,-DESXDOS))
$(eval $(call zx_support,rs232plus,rs232/plus3))
$(eval $(call zx_support,rs232if1,rs232/if1))
$(eval $(call zx_support,rs232morex,rs232/morex))

ZX_SUPPORT_LIBS := p3.lib zxmdv.lib zxbasdrv.lib zxbasdos.lib esxdos.lib rs232plus.lib rs232if1.lib rs232morex.lib
ZX_LIBS := zx_clib.lib zxcpm.lib mzx.lib mzx_tiny.lib $(ZX_SUPPORT_LIBS)
TOCREATE += $(call check_target,zx,$(ZX_LIBS))

# ZX Spectrum libraries
zx_clib.lib: $(TARGET_CLIB_DEPS) $(ZX_TARGETS) $(FZX_TARGETS) $(ZX_SUPPORT_LIBS)
	@echo ''
	@echo '--- Building ZX Spectrum Library ---'
	@echo ''
	TARGET=zx TYPE=z80 $(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS $(COLDEFS) -Itarget/zx/newlib -x$(OUTPUT_DIRECTORY)/zx_clib @$(TARGET_DIRECTORY)/zx/zx.lst

zxcpm.lib: $(TARGET_CLIB_DEPS) $(ZX_TARGETS) zx_clib.lib
	@echo ''
	@echo '--- Building ZX Spectrum CP/M Library ---'
	@echo ''
	TARGET=zx TYPE=z80 $(LIBLINKER) -DFORzx $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zxcpm @$(TARGET_DIRECTORY)/zx/zx_cpm.lst

p3.lib: $(ZX_plus3_OBJECTS) target/zx/classic/fcntl/plus3/plus3.lst
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/p3 @target/zx/classic/fcntl/plus3/plus3.lst

zxmdv.lib: $(ZX_microdrive_OBJECTS) target/zx/classic/fcntl/microdrive/mdvlist
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zxmdv @target/zx/classic/fcntl/microdrive/mdvlist

zxbasdrv.lib: $(ZX_zxbasdrv_OBJECTS) target/zx/classic/fcntl/zxbasdrv/zxbdlst
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zxbasdrv @target/zx/classic/fcntl/zxbasdrv/zxbdlst

zxbasdos.lib: $(ZX_zxbasdrv_OBJECTS) target/zx/classic/fcntl/zxbasdrv/zxbdlst2
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zxbasdos @target/zx/classic/fcntl/zxbasdrv/zxbdlst2

esxdos.lib: $(ZX_esxdos_OBJECTS) target/zx/classic/fcntl/esxdos/esxdos.lst
	$(LIBLINKER) -I$(Z88DK_LIB) -x$(OUTPUT_DIRECTORY)/esxdos @target/zx/classic/fcntl/esxdos/esxdos.lst

rs232plus.lib: $(ZX_rs232plus_OBJECTS) target/zx/classic/rs232/plus3/p3list
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/rs232plus @target/zx/classic/rs232/plus3/p3list

rs232if1.lib: $(ZX_rs232if1_OBJECTS) target/zx/classic/rs232/if1/if1list
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/rs232if1 @target/zx/classic/rs232/if1/if1list

rs232morex.lib: $(ZX_rs232morex_OBJECTS) target/zx/classic/rs232/morex/morexlist
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/rs232morex @target/zx/classic/rs232/morex/morexlist

target-zx-clean:
	$(RM) -fr target/zx/obj
	$(RM) p3.lib zxmdv.lib zxbasdrv.lib zxbasdos.lib esxdos.lib rs232plus.lib rs232if1.lib rs232morex.lib
