MZ800_GLOBS := \
	"target/mz800/games/*.asm" \
	"target/mz800/graphics/*.asm" \
	"target/mz800/mz800/*.asm" \
	"target/mz800/input/*.asm" \
	"target/mz800/stdio/*.asm"

MZ800_GLOBS_ex := \
	target/mz800/games/*.asm \
	target/mz800/graphics/*.asm \
	target/mz800/mz800/*.asm \
	target/mz800/input/*.asm \
	target/mz800/stdio/*.asm

MZ800_TARGETS := target/mz800/obj/target-mz800-mz800 \
	classic/games/obj/.stamp-mz800 classic/gfx/obj/.stamp-mz800

CLEAN += target-mz800-clean
TOCREATE += $(call check_target,mz800,mz800_clib.lib)
$(eval $(call gfx_stamp_args,mz800,TARGET=mz800 FLAVOUR=wide))
$(eval $(call buildtargetasm,target/mz800,z80,mz800,-mz80,$(MZ800_GLOBS),$(MZ800_GLOBS_ex)))

mz800_clib.lib: $(TARGET_CLIB_DEPS) $(MZ800_TARGETS)
	@echo ''
	@echo '--- Building Sharp MZ-800 Library ---'
	@echo ''
	TARGET=mz800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmz800 -x$(OUTPUT_DIRECTORY)/mz800_clib @$(TARGET_DIRECTORY)/mz800/mz800.lst

target-mz800: $(MZ800_TARGETS)

.PHONY: target-mz800 target-mz800-clean

target-mz800-clean:
	$(RM) -fr target/mz800/obj
