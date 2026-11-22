NASCOM_GLOBS := \
	"target/nascom/graphics/*.asm" \
	"target/nascom/stdio/*.asm" \
	"target/nascom/stdio/ansi/*.asm"

NASCOM_GLOBS_ex := \
	target/nascom/graphics/*.asm \
	target/nascom/stdio/*.asm \
	target/nascom/stdio/ansi/*.asm

NASCOM_TARGETS := target/nascom/obj/target-nascom-nascom \
	classic/games/obj/.stamp-nascom \
	classic/gfx/obj/.stamp-nascom

$(eval $(call gfx_stamp_args,nascom,TARGET=nascom FLAVOUR="gencon narrow"))
CLEAN += target-nascom-clean
TOCREATE += $(call check_target,nascom,nascom_clib.lib nascomcpm.lib)
$(eval $(call buildtargetasm,target/nascom,z80,nascom,-mz80,$(NASCOM_GLOBS),$(NASCOM_GLOBS_ex)))

nascom_clib.lib: $(TARGET_CLIB_DEPS) $(NASCOM_TARGETS)
	TARGET=nascom TYPE=z80 $(LIBLINKER) -DFORnascom -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/nascom_clib @$(TARGET_DIRECTORY)/nascom/nascom.lst
	@touch $@

nascomcpm.lib: $(TARGET_CLIB_DEPS) $(NASCOM_TARGETS)
	TARGET=nascom TYPE=z80 $(LIBLINKER) -DFORnascom -DFORnascomcpm -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/nascomcpm @$(TARGET_DIRECTORY)/nascom/nascomcpm.lst
	@touch $@

target-nascom: $(NASCOM_TARGETS)

.PHONY: target-nascom target-nascom-clean

target-nascom-clean:
	$(RM) -fr target/nascom/obj
