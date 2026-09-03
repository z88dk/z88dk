MULTI8_GLOBS := \
	"target/multi8/graphics/*.asm" \
	"target/multi8/*.asm" \
	"target/multi8/psg/*.asm" \
	"target/multi8/stdio/*.asm" 

MULTI8_GLOBS_ex := \
	target/multi8/graphics/*.asm \
	target/multi8/*.asm \
	target/multi8/psg/*.asm \
	target/multi8/stdio/*.asm 


MULTI8_TARGETS := target/multi8/obj/target-multi8-multi8 classic/games/obj/.stamp-multi8 classic/gfx/obj/.stamp-multi8
		

CLEAN += target-multi8-clean
TOCREATE += $(call check_target,multi8,multi8_clib.lib)
$(eval $(call gfx_stamp_args,multi8,TARGET=multi8 FLAVOUR=wide))
$(eval $(call buildtargetasm,target/multi8,z80,multi8,-mz80,$(MULTI8_GLOBS),$(MULTI8_GLOBS_ex)))

multi8_clib.lib: $(TARGET_CLIB_DEPS) $(MULTI8_TARGETS)
	@echo ''
	@echo '--- Building Mitsubishi Multi8 Library ---'
	@echo ''
	TARGET=multi8 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmulti8 -x$(OUTPUT_DIRECTORY)/multi8_clib @$(TARGET_DIRECTORY)/multi8/multi8.lst



target-multi8: $(MULTI8_TARGETS)

.PHONY: target-multi8 target-multi8-clean



target-multi8-clean:
	$(RM) -fr target/multi8/obj
