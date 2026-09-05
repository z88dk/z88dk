FP1100_SOURCES := $(call rwildcard,target/fp1100,*.asm)
FP1100_TARGETS := target/fp1100/obj/target-fp1100-fp1100 \
	classic/games/obj/.stamp-cpm-fp1100 \
	classic/gfx/obj/.stamp-fp1100

$(eval $(call gfx_stamp_args,fp1100,TARGET=fp1100 FLAVOUR=wide))
CLEAN += target-fp1100-clean
TOCREATE += $(call check_target,fp1100,fp1100_clib.lib fp1100_cpm.lib)
$(eval $(call buildtargetasm,target/fp1100,z80,fp1100,-mz80,$(FP1100_SOURCES),$(FP1100_SOURCES)))

fp1100_clib.lib: $(TARGET_CLIB_DEPS) $(FP1100_TARGETS)
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_clib @$(TARGET_DIRECTORY)/fp1100/fp1100.lst
	@touch $@

fp1100_cpm.lib: fp1100_clib.lib $(TARGET_CLIB_DEPS) $(FP1100_TARGETS)
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_cpm @$(TARGET_DIRECTORY)/fp1100/fp1100_cpm.lst
	@touch $@

target-fp1100: $(FP1100_TARGETS)

.PHONY: target-fp1100 target-fp1100-clean

target-fp1100-clean:
	$(RM) -fr target/fp1100/obj
