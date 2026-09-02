AUSSIE_GLOBS := \
	"target/aussie/games/*.asm" \
	"target/aussie/graphics/*.asm"

AUSSIE_GLOBS_ex := \
	target/aussie/games/*.asm \
	target/aussie/graphics/*.asm


AUSSIE_TARGETS := target/aussie/obj/target-aussie-aussie classic/games/obj/.stamp-cpm-aussie classic/gfx/obj/.stamp-cpm-aussie


CLEAN += target-aussie-clean
aussie.lib: cpm_clib.lib $(AUSSIE_TARGETS)
	@echo ''
	@echo '--- Building Aussie Byte Library ---'
	@echo ''
	TARGET=aussie TYPE=z80 $(LIBLINKER) -DFORaussie -x$(OUTPUT_DIRECTORY)/aussie.lib @$(TARGET_DIRECTORY)/aussie/aussie.lst

TOCREATE += $(call check_target,aussie,aussie.lib $(CPMLIBS))

target-aussie: $(AUSSIE_TARGETS)

.PHONY: target-aussie target-aussie-clean

$(eval $(call buildtargetasm,target/aussie,z80,aussie,-mz80,$(AUSSIE_GLOBS),$(AUSSIE_GLOBS_ex)))

target-aussie-clean:
	$(RM) -fr target/aussie/obj
