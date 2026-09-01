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

CLEAN += target-zx81-clean

target-zx81: $(ZX81_TARGETS)

.PHONY: target-zx81 target-zx81-clean

define buildzx81asm
target/zx81/obj/target-zx81-$(2): $(3)
	@mkdir -p target/zx81/obj/$(2)
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
