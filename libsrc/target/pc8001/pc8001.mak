PC8001_GLOBS := \
	"target/pc8001/*.asm" \
	"target/pc8001/games/*.asm" \
	"target/pc8001/graphics/*.asm" \
	"target/pc8001/hires/*.asm" \
	"target/pc8001/input/*.asm" \
	"target/pc8001/stdio/*.asm"

PC8001_GLOBS_ex := \
	target/pc8001/*.asm \
	target/pc8001/games/*.asm \
	target/pc8001/graphics/*.asm \
	target/pc8001/hires/*.asm \
	target/pc8001/input/*.asm \
	target/pc8001/stdio/*.asm


PC8001_TARGETS := target/pc8001/obj/target-pc8001-pc8001 classic/gfx/obj/.stamp-pc8001 classic/games/obj/.stamp-pc8001

$(eval $(call gfx_stamp_args,pc8001,TARGET=pc8001 FLAVOUR=wide))
CLEAN += target-pc8001-clean
TOCREATE += $(call check_target,pc8001,pc8001_clib.lib)
$(eval $(call buildtargetasm,target/pc8001,z80,pc8001,-mz80,$(PC8001_GLOBS),$(PC8001_GLOBS_ex)))

pc8001_clib.lib: $(TARGET_CLIB_DEPS) $(PC8001_TARGETS)
	TARGET=pc8001 TYPE=z80 $(LIBLINKER) -DFORpc8001 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc8001_clib @$(TARGET_DIRECTORY)/pc8001/pc8001.lst


target-pc8001: $(PC8001_TARGETS)

.PHONY: target-pc8001 target-pc8001-clean

target-pc8001-clean:
	$(RM) -fr target/pc8001/obj
