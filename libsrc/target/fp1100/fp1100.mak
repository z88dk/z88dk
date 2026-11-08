FP1100_SOURCES := $(call rwildcard,target/fp1100,*.asm)
FP1100_TARGETS := target/fp1100/obj/target-fp1100-fp1100 \
	classic/games/obj/.stamp-cpm-fp1100 \
	classic/gfx/obj/.stamp-fp1100

$(eval $(call gfx_stamp_args,fp1100,TARGET=fp1100 FLAVOUR=wide))
CLEAN += target-fp1100-clean
TOCREATE += $(call check_target,fp1100,fp1100_clib.lib fp1100_cpm.lib fp1100_allram.lib)
$(eval $(call buildtargetasm,target/fp1100,z80,fp1100,-mz80,$(FP1100_SOURCES),$(FP1100_SOURCES)))

# The all-RAM sub-CPU program: the modules that INCLUDE its define file are rebuilt when it changes, and takeover.asm (which BINARYs the program and the
# loader in) when they change: the assembler does not know about either, so touch the source and it assembles it again.
FP1100_SUB := target/fp1100/allram/sub
FP1100_SUBINC_USERS := $(shell grep -l 'sub/sub.inc' $(FP1100_SOURCES))
$(FP1100_SUBINC_USERS): $(FP1100_SUB)/sub.inc
	@touch $@
target/fp1100/allram/stdio/takeover.asm: $(FP1100_SUB)/sub.bin $(FP1100_SUB)/sub2.bin $(FP1100_SUB)/loader.bin

fp1100_clib.lib: $(TARGET_CLIB_DEPS) $(FP1100_TARGETS)
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_clib @$(TARGET_DIRECTORY)/fp1100/fp1100.lst
	@touch $@

fp1100_cpm.lib: fp1100_clib.lib $(TARGET_CLIB_DEPS) $(FP1100_TARGETS)
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_cpm @$(TARGET_DIRECTORY)/fp1100/fp1100_cpm.lst
	@touch $@

# The all-RAM overlay: linked before fp1100_clib.lib (lib/config/fp1100.cfg, -clib=allram), see doc/target/fp1100/subcpu-plan.md
fp1100_allram.lib: fp1100_clib.lib $(TARGET_CLIB_DEPS) $(FP1100_TARGETS)
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_allram @$(TARGET_DIRECTORY)/fp1100/fp1100_allram.lst
	@touch $@

target-fp1100: $(FP1100_TARGETS)

.PHONY: target-fp1100 target-fp1100-clean

target-fp1100-clean:
	$(RM) -fr target/fp1100/obj
