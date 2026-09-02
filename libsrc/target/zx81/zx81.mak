ZX81_BASE_GLOBS := \
	"target/zx81/games/*.asm" \
	"target/zx81/graphics/*.asm" \
	"target/zx81/graphics_gray/*.asm" \
	"target/zx81/graphics_hr/*.asm" \
	"target/zx81/graphics_phrg/*.asm" \
	"target/zx81/graphics_udg/*.asm" \
	"target/zx81/input/*.asm" \
	"target/zx81/psg/*.asm" \
	"target/zx81/stdio/*.asm" \
	"target/zx81/stdio/ansi/*.asm" \
	"target/zx81/stdio/ansi_text/*.asm" \
	"target/zx81/stdio/conio/*.asm" \
	"target/zx81/time/*.asm" \
	"target/zx81/zx81/*.asm" \
	"target/zx81/zx81/basic/*.asm" \
	"target/zx81/zx81/chroma81/*.asm" \
	"target/zx81/zx81/tape/*.asm"

ZX81_BASE_GLOBS_ex := \
	target/zx81/games/*.asm \
	target/zx81/graphics/*.asm \
	target/zx81/graphics_gray/*.asm \
	target/zx81/graphics_hr/*.asm \
	target/zx81/graphics_phrg/*.asm \
	target/zx81/graphics_udg/*.asm \
	target/zx81/input/*.asm \
	target/zx81/psg/*.asm \
	target/zx81/stdio/*.asm \
	target/zx81/stdio/ansi/*.asm \
	target/zx81/stdio/ansi_text/*.asm \
	target/zx81/stdio/conio/*.asm \
	target/zx81/time/*.asm \
	target/zx81/zx81/*.asm \
	target/zx81/zx81/basic/*.asm \
	target/zx81/zx81/chroma81/*.asm \
	target/zx81/zx81/tape/*.asm

ZX81_GFX_GLOBS := \
	"target/zx81/graphics/*.asm" \
	"target/zx81/stdio/ansi_text/*.asm"

ZX81_GFX_GLOBS_ex := \
	target/zx81/graphics/*.asm \
	target/zx81/stdio/ansi_text/*.asm

ZX81_PHRG_GLOBS := "target/zx81/graphics/*.asm" "target/zx81/graphics_phrg/*.asm"
ZX81_PHRG_GLOBS_ex := target/zx81/graphics/*.asm target/zx81/graphics_phrg/*.asm

ZX81_UDG_GLOBS := $(ZX81_GFX_GLOBS) "target/zx81/graphics_udg/*.asm"
ZX81_UDG_GLOBS_ex := $(ZX81_GFX_GLOBS_ex) target/zx81/graphics_udg/*.asm

ZX81_HR_GLOBS := \
	"target/zx81/graphics/*.asm" \
	"target/zx81/stdio/ansi/*.asm" \
	"target/zx81/graphics_gray/*.asm" \
	"target/zx81/graphics_hr/*.asm"

ZX81_HR_GLOBS_ex := \
	target/zx81/graphics/*.asm \
	target/zx81/stdio/ansi/*.asm \
	target/zx81/graphics_gray/*.asm \
	target/zx81/graphics_hr/*.asm

ZX81_HRI_GLOBS := \
	"target/zx81/graphics_hr/*.asm" \
	"target/zx81/stdio/ansi/*.asm"

ZX81_HRI_GLOBS_ex := \
	target/zx81/graphics_hr/*.asm \
	target/zx81/stdio/ansi/*.asm

ZX81_BASE_TARGETS := \
	target/zx81/obj/target-zx81-zx81 \
	classic/games/obj/.stamp-zx81 \
	classic/gfx/obj/.stamp-zx81

LAMBDA_TARGETS := \
	$(ZX81_BASE_TARGETS) \
	target/zx81/obj/target-zx81-lambda \
	classic/gfx/obj/.stamp-zx81-lambda

GFX81_TARGETS := $(ZX81_BASE_TARGETS)
GFX81PHRG_TARGETS := target/zx81/obj/target-zx81-zx81phrg classic/gfx/obj/.stamp-zx81-phrg
GFX81UDG_TARGETS := target/zx81/obj/target-zx81-zx81udg classic/gfx/obj/.stamp-zx81-udg
GFX81HR64_TARGETS := target/zx81/obj/target-zx81-zx81hr64 classic/gfx/obj/.stamp-zx81-hr64
GFX81G64_TARGETS := target/zx81/obj/target-zx81-zx81g64 classic/gfx/obj/.stamp-zx81-g64
GFX81MT64_TARGETS := target/zx81/obj/target-zx81-zx81mt64 classic/gfx/obj/.stamp-zx81-mt64
GFX81HR128_TARGETS := target/zx81/obj/target-zx81-zx81hr128 classic/gfx/obj/.stamp-zx81-hr128
GFX81HR192_TARGETS := target/zx81/obj/target-zx81-zx81hr192 classic/gfx/obj/.stamp-zx81-hr192
GFX81MT192_TARGETS := target/zx81/obj/target-zx81-zx81mt192 classic/gfx/obj/.stamp-zx81-mt192
GFX81G007_TARGETS := target/zx81/obj/target-zx81-zx81g007 classic/gfx/obj/.stamp-zx81-g007
GFX81HR384_TARGETS := target/zx81/obj/target-zx81-zx81hr384 classic/gfx/obj/.stamp-zx81-hr384

$(eval $(call gfx_stamp_args,zx81,TARGET=zx81 FLAVOUR=narrow))
$(eval $(call gfx_stamp_args,zx81-phrg,TARGET=zx81 FLAVOUR=narrow SUBTYPE=zx81phrg))
$(eval $(call gfx_stamp_args,zx81-lambda,TARGET=zx81 FLAVOUR=narrow SUBTYPE=lambda))
$(eval $(call gfx_stamp_args,zx81-udg,TARGET=zx81 SUBTYPE=zx81udg FLAVOUR="narrow text6"))
$(eval $(call gfx_stamp_args,zx81-hr64,TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81hr64))
$(eval $(call gfx_stamp_args,zx81-g64,TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81g64))
$(eval $(call gfx_stamp_args,zx81-mt64,TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81mt64))
$(eval $(call gfx_stamp_args,zx81-hr128,TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81hr128))
$(eval $(call gfx_stamp_args,zx81-hr192,TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81hr192))
$(eval $(call gfx_stamp_args,zx81-mt192,TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81mt192))
$(eval $(call gfx_stamp_args,zx81-g007,TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81g007))
$(eval $(call gfx_stamp_args,zx81-hr384,TARGET=zx81 FLAVOUR=wide SUBTYPE=zx81hr384))

ZX81_TARGETS := \
	$(ZX81_BASE_TARGETS) \
	$(LAMBDA_TARGETS) \
	$(GFX81PHRG_TARGETS) $(GFX81UDG_TARGETS) \
	$(GFX81HR64_TARGETS) $(GFX81G64_TARGETS) $(GFX81MT64_TARGETS) \
	$(GFX81HR128_TARGETS) $(GFX81HR192_TARGETS) $(GFX81MT192_TARGETS) \
	$(GFX81G007_TARGETS) $(GFX81HR384_TARGETS)

zx81_clib.lib: $(TARGET_CLIB_DEPS) zx80_clib.lib $(ZX81_BASE_TARGETS)
	TARGET=zx81 TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS -IXIY -DFORzx81 $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zx81_clib @$(TARGET_DIRECTORY)/zx81/zx81.lst

lambda_clib.lib: $(TARGET_CLIB_DEPS) zx81_clib.lib $(LAMBDA_TARGETS)
	TARGET=zx81 SUBTARGET=lambda TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS -IXIY -DFORlambda -x$(OUTPUT_DIRECTORY)/lambda_clib @$(TARGET_DIRECTORY)/zx81/zx81.lst

gfx81.lib: $(TARGET_CLIB_DEPS) lambda_clib.lib $(GFX81_TARGETS)
	TARGET=zx81 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81 -x$(OUTPUT_DIRECTORY)/gfx81 @$(TARGET_DIRECTORY)/zx81/gfx81.lst
	@touch $@

gfx81phrg.lib: $(TARGET_CLIB_DEPS) lambda_clib.lib $(GFX81PHRG_TARGETS)
	TARGET=zx81phrg TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81phrg -x$(OUTPUT_DIRECTORY)/gfx81phrg @$(TARGET_DIRECTORY)/zx81/gfx81phrg.lst
	@touch $@

gfxlambda.lib: $(TARGET_CLIB_DEPS) gfx81.lib $(LAMBDA_TARGETS)
	TARGET=lambda TYPE=ixiy $(LIBLINKER) -IXIY -DFORlambda -x$(OUTPUT_DIRECTORY)/gfxlambda @$(TARGET_DIRECTORY)/zx81/gfx81.lst

gfx81udg.lib: $(TARGET_CLIB_DEPS) gfxlambda.lib $(GFX81UDG_TARGETS)
	TARGET=zx81udg TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81udg -x$(OUTPUT_DIRECTORY)/gfx81udg @$(TARGET_DIRECTORY)/zx81/gfx81udg.lst

gfx81hr64.lib: $(TARGET_CLIB_DEPS) gfx81udg.lib $(GFX81HR64_TARGETS)
	TARGET=zx81hr64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr64 -x$(OUTPUT_DIRECTORY)/gfx81hr64 @$(TARGET_DIRECTORY)/zx81/gfx81hr.lst
	@touch $@

gfx81arx64.lib: $(TARGET_CLIB_DEPS) gfx81udg.lib $(GFX81HR64_TARGETS)
	TARGET=zx81hr64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr64 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx64 @$(TARGET_DIRECTORY)/zx81/gfx81arx.lst
	@touch $@

gfx81g064.lib: $(TARGET_CLIB_DEPS) gfx81udg.lib $(GFX81G64_TARGETS)
	TARGET=zx81g64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81g64 -DG007 -x$(OUTPUT_DIRECTORY)/gfx81g064 @$(TARGET_DIRECTORY)/zx81/gfx81g007.lst
	@touch $@

gfx81mt64.lib: $(TARGET_CLIB_DEPS) gfx81udg.lib $(GFX81MT64_TARGETS)
	TARGET=zx81mt64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81mt64 -DMTHRG -x$(OUTPUT_DIRECTORY)/gfx81mt64 @$(TARGET_DIRECTORY)/zx81/gfx81mt.lst
	@touch $@

gfx81hr128.lib: $(TARGET_CLIB_DEPS) gfx81hr64.lib $(GFX81HR128_TARGETS)
	TARGET=zx81hr128 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr128 -x$(OUTPUT_DIRECTORY)/gfx81hr128 @$(TARGET_DIRECTORY)/zx81/gfx81hr.lst
	@touch $@

gfx81arx128.lib: $(TARGET_CLIB_DEPS) gfx81hr64.lib $(GFX81HR128_TARGETS)
	TARGET=zx81hr128 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr128 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx128 @$(TARGET_DIRECTORY)/zx81/gfx81arx.lst
	@touch $@

gfx81hr192.lib: $(TARGET_CLIB_DEPS) gfx81hr128.lib $(GFX81HR192_TARGETS)
	TARGET=zx81hr192 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr192 -x$(OUTPUT_DIRECTORY)/gfx81hr192 @$(TARGET_DIRECTORY)/zx81/gfx81hr.lst
	@touch $@

gfx81arx192.lib: $(TARGET_CLIB_DEPS) gfx81hr128.lib $(GFX81HR192_TARGETS)
	TARGET=zx81hr192 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr192 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx192 @$(TARGET_DIRECTORY)/zx81/gfx81arx.lst
	@touch $@

gfx81mt192.lib: $(TARGET_CLIB_DEPS) gfx81hr128.lib $(GFX81MT192_TARGETS)
	TARGET=zx81mt192 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81mt192 -DMTHRG -x$(OUTPUT_DIRECTORY)/gfx81mt192 @$(TARGET_DIRECTORY)/zx81/gfx81mt.lst
	@touch $@

gfx81g007.lib: $(TARGET_CLIB_DEPS) gfx81hr128.lib $(GFX81G007_TARGETS)
	TARGET=zx81g007 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81g007 -DG007 -x$(OUTPUT_DIRECTORY)/gfx81g007 @$(TARGET_DIRECTORY)/zx81/gfx81g007.lst
	@touch $@

gfx81hr384.lib: $(TARGET_CLIB_DEPS) gfx81hr128.lib $(GFX81HR384_TARGETS)
	TARGET=zx81hr384 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr384 -x$(OUTPUT_DIRECTORY)/gfx81hr384 @$(TARGET_DIRECTORY)/zx81/gfx81hri.lst
	@touch $@

m81.lib:
	$(MAKE) -C math/float/zxmath m81

m81_tiny.lib:
	$(MAKE) -C math/float/zxmath m81_tiny

mlambda.lib:
	$(MAKE) -C math/float/zxmath mlambda
	$(MAKE) -C math/float/zxmath mlambdav1
	$(MAKE) -C math/float/zxmath mlambdav3

mlambda_tiny.lib:
	$(MAKE) -C math/float/zxmath mlambda_tiny
	$(MAKE) -C math/float/zxmath mlambdav1_tiny
	$(MAKE) -C math/float/zxmath mlambdav3_tiny

CLEAN += target-zx81-clean
TOCREATE += $(call check_target,lambda, mlambda.lib mlambda_tiny.lib lambda_clib.lib gfxlambda.lib )
TOCREATE += $(call check_target,zx81, zx81_clib.lib gfx81.lib gfx81udg.lib gfx81hr64.lib gfx81hr128.lib gfx81hr192.lib gfx81hr384.lib m81.lib m81_tiny.lib gfx81phrg.lib gfx81arx64.lib gfx81g064.lib gfx81mt64.lib gfx81arx128.lib gfx81arx192.lib gfx81mt192.lib gfx81g007.lib)

target-zx81: $(ZX81_TARGETS)

.PHONY: target-zx81 target-zx81-clean

define buildzx81asm
target/zx81/obj/target-zx81-$(2): $(3)
	$(Q)mkdir -p target/zx81/obj/$(2)
	$(Q)$(ASSEMBLER) -d -O=target/zx81/obj/$(2)/x -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I$(Z88DK_LIBSRC)/target/zx81 -I$(Z88DK_LIB) -I$(Z88DK_LIB)/target/zx81/def -Itarget/zx81 -Itarget/zx81/obj/$(2) -I$(Z88DK_LIBSRC)/classic $(4) -I$(Z88DK_LIB) -D__CLASSIC -DFOR$(2) $(1)
	$(Q)touch $$@
endef

$(eval $(call buildzx81asm,$(ZX81_BASE_GLOBS),zx81,$(ZX81_BASE_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_PHRG_GLOBS),zx81phrg,$(ZX81_PHRG_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_GFX_GLOBS),lambda,$(ZX81_GFX_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_UDG_GLOBS),zx81udg,$(ZX81_UDG_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_HR_GLOBS),zx81hr64,$(ZX81_HR_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_HR_GLOBS),zx81g64,$(ZX81_HR_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_HR_GLOBS),zx81mt64,$(ZX81_HR_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_HR_GLOBS),zx81hr128,$(ZX81_HR_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_HR_GLOBS),zx81hr192,$(ZX81_HR_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_HR_GLOBS),zx81mt192,$(ZX81_HR_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_HR_GLOBS),zx81g007,$(ZX81_HR_GLOBS_ex),-IXIY))
$(eval $(call buildzx81asm,$(ZX81_HRI_GLOBS),zx81hr384,$(ZX81_HRI_GLOBS_ex),-IXIY))

target-zx81-clean:
	$(RM) -fr target/zx81/obj
