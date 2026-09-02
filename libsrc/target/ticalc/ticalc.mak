TICALC_GLOBS := \
	"target/ticalc/games/*.asm" \
	"target/ticalc/graphics/*.asm" \
	"target/ticalc/graphics/gray/*.asm" \
	"target/ticalc/stdio/*.asm" \
	"target/ticalc/stdio/ansi/*.asm"

TICALC_GLOBS_ex := \
	target/ticalc/games/*.asm \
	target/ticalc/graphics/*.asm \
	target/ticalc/graphics/gray/*.asm \
	target/ticalc/stdio/*.asm \
	target/ticalc/stdio/ansi/*.asm

define ticalc_targets
TICALC_$(1)_TARGETS := \
	target/ticalc/obj/target-ticalc-$(1) \
	classic/games/obj/.stamp-$(1) \
	classic/gfx/obj/.stamp-$(1)
endef

$(foreach target,ti82 ti83 ti83p ti85 ti86,$(eval $(call gfx_stamp_args,$(target),TARGET=$(target) FLAVOUR="gray narrow")))

$(foreach target,ti82 ti83 ti83p ti85 ti86,$(eval $(call ticalc_targets,$(target))))

TICALC_TARGETS := $(TICALC_ti82_TARGETS) $(TICALC_ti83_TARGETS) $(TICALC_ti83p_TARGETS) $(TICALC_ti85_TARGETS) $(TICALC_ti86_TARGETS)

define ticalc_library
$(1)_clib.lib: $(TARGET_CLIB_DEPS) $$(TICALC_$(1)_TARGETS)
	TARGET=$(1) TYPE=z80 $$(LIBLINKER) -DSTANDARDESCAPECHARS -DFOR$(1) -DPACKEDFONT -x$$(OUTPUT_DIRECTORY)/$(1)_clib @$$(TARGET_DIRECTORY)/ticalc/ticalc.lst
endef

$(foreach target,ti82 ti83 ti83p ti85 ti86,$(eval $(call ticalc_library,$(target))))

CLEAN += target-ticalc-clean
TOCREATE += $(call check_target,ti82,ti82_clib.lib)
TOCREATE += $(call check_target,ti83,ti83_clib.lib)
TOCREATE += $(call check_target,ti83p,ti83p_clib.lib)
TOCREATE += $(call check_target,ti85,ti85_clib.lib)
TOCREATE += $(call check_target,ti86,ti86_clib.lib)

target-ticalc: $(TICALC_TARGETS)

.PHONY: target-ticalc target-ticalc-clean

$(foreach target,ti82 ti83 ti83p ti85 ti86,$(eval \
	$(call buildtargetasm,target/ticalc,z80,$(target),-mz80,$(TICALC_GLOBS),$(TICALC_GLOBS_ex))))

target-ticalc-clean:
	$(RM) -fr target/ticalc/obj
