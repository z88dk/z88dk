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

CLEAN += target-ticalc-clean

target-ticalc: $(TICALC_TARGETS)

.PHONY: target-ticalc target-ticalc-clean

$(foreach target,ti82 ti83 ti83p ti85 ti86,$(eval \
	$(call buildtargetasm,target/ticalc,z80,$(target),-mz80,$(TICALC_GLOBS),$(TICALC_GLOBS_ex))))

target-ticalc-clean:
	$(RM) -fr target/ticalc/obj
