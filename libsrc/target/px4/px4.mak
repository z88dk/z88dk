PX4_GLOBS := \
	"target/px4/graphics/*.asm" \
	"target/px4/stdio/ansi/*.asm"

PX4_GLOBS_ex := \
	target/px4/graphics/*.asm \
	target/px4/stdio/ansi/*.asm


PX4_TARGETS := target/px4/obj/target-px4-px4 classic/games/obj/.stamp-cpm-px4 classic/gfx/obj/.stamp-cpm-px4


CLEAN += target-px4-clean
TOCREATE += $(call check_target,px4,px4.lib $(CPMLIBS))
$(eval $(call buildtargetasm,target/px4,z80,px4,-mz80,$(PX4_GLOBS),$(PX4_GLOBS_ex)))

px4.lib: cpm_clib.lib $(PX4_TARGETS)
	@echo ''
	@echo '--- Building PX-4/HC-40 Library ---'
	@echo ''
	TARGET=px4 TYPE=z80 $(LIBLINKER) -DFORpx4 -x$(OUTPUT_DIRECTORY)/px4 @$(TARGET_DIRECTORY)/px4/px4.lst


target-px4: $(PX4_TARGETS)

.PHONY: target-px4 target-px4-clean


target-px4-clean:
	$(RM) -fr target/px4/obj
