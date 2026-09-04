TIM011_GLOBS := \
	"target/tim011/graphics/*.asm" \
	"target/tim011/stdio/*.asm" 

TIM011_GLOBS_ex := \
	target/tim011/graphics/*.asm \
	target/tim011/stdio/*.asm 


TIM011_TARGETS := target/tim011/obj/target-tim011-tim011 classic/games/obj/.stamp-cpm-tim011 classic/gfx/obj/.stamp-cpm-tim011
		

CLEAN += target-tim011-clean
TOCREATE += $(call check_target,tim011,tim011.lib)
$(eval $(call gfx_stamp_portable_args,cpm-tim011,TARGET=cpm SUBTYPE=tim011 FLAVOUR="wide gencon" TARGET_CFLAGS="-subtype=tim011"))
$(eval $(call buildtargetasm,target/tim011,z180,tim011,-mz180,$(TIM011_GLOBS),$(TIM011_GLOBS_ex)))

tim011.lib: cpm_clib.lib $(TIM011_TARGETS)
	@echo ''
	@echo '--- Building Tim-011 Library ---'
	@echo ''
	TARGET=tim011 TYPE=z180 $(LIBLINKER) -mz180 -DFORtim011 -x$(OUTPUT_DIRECTORY)/tim011.lib @$(TARGET_DIRECTORY)/tim011/tim011.lst



target-tim011: $(TIM011_TARGETS)

.PHONY: target-tim011 target-tim011-clean



target-tim011-clean:
	$(RM) -fr target/tim011/obj
