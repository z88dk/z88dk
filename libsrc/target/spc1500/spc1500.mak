SPC1500_GLOBS := \
	"target/spc1500/games/*.asm" \
	"target/spc1500/graphics/*.asm" \
	"target/spc1500/input/*.asm" \
	"target/spc1500/psg/*.asm" \
	"target/spc1500/spc1500/*.asm" \
	"target/spc1500/stdio/*.asm"

SPC1500_GLOBS_ex := \
	target/spc1500/games/*.asm \
	target/spc1500/graphics/*.asm \
	target/spc1500/input/*.asm \
	target/spc1500/psg/*.asm \
	target/spc1500/spc1500/*.asm \
	target/spc1500/stdio/*.asm

SPC1500_TARGETS := target/spc1500/obj/target-spc1500-spc1500 \
	classic/games/obj/.stamp-spc1500 classic/gfx/obj/.stamp-spc1500

CLEAN += target-spc1500-clean
TOCREATE += $(call check_target,spc1500,spc1500_clib.lib)
$(eval $(call gfx_stamp_args,spc1500,TARGET=spc1500 FLAVOUR=wide))
$(eval $(call buildtargetasm,target/spc1500,z80,spc1500,-mz80,$(SPC1500_GLOBS),$(SPC1500_GLOBS_ex)))

spc1500_clib.lib: $(TARGET_CLIB_DEPS) $(SPC1500_TARGETS)
	@echo ''
	@echo '--- Building Samsung SPC-1500 Library ---'
	@echo ''
	TARGET=spc1500 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORspc1500 -x$(OUTPUT_DIRECTORY)/spc1500_clib @$(TARGET_DIRECTORY)/spc1500/spc1500.lst

target-spc1500: $(SPC1500_TARGETS)

.PHONY: target-spc1500 target-spc1500-clean

target-spc1500-clean:
	$(RM) -fr target/spc1500/obj
