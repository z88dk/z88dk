PC88_GLOBS := \
	"target/pc88/*.asm" \
	"target/pc88/games/*.asm" \
	"target/pc88/graphics/*.asm" \
	"target/pc88/interrupt/*.asm" \
	"target/pc88/psg/*.asm" \
	"target/pc88/stdio/*.asm" \
	"target/pc88/time/*.asm" 

PC88_GLOBS_ex := \
	target/pc88/*.asm \
	target/pc88/games/*.asm \
	target/pc88/graphics/*.asm \
	target/pc88/interrupt/*.asm \
	target/pc88/psg/*.asm \
	target/pc88/stdio/*.asm \
	target/pc88/time/*.asm 


PC88_TARGETS := target/pc88/obj/target-pc88-pc88 classic/games/obj/.stamp-pc88 classic/gfx/obj/.stamp-pc88

$(eval $(call gfx_stamp_args,pc88,TARGET=pc88 FLAVOUR=wide))
CLEAN += target-pc88-clean
TOCREATE += $(call check_target,pc88,pc88_clib.lib)
$(eval $(call buildtargetasm,target/pc88,z80,pc88,-mz80,$(PC88_GLOBS),$(PC88_GLOBS_ex)))

pc88_clib.lib: $(TARGET_CLIB_DEPS) $(PC88_TARGETS)
	TARGET=pc88 TYPE=z80 $(LIBLINKER) -DFORpc88 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc88_clib @$(TARGET_DIRECTORY)/pc88/pc88.lst

		


target-pc88: $(PC88_TARGETS)

.PHONY: target-pc88 target-pc88-clean



target-pc88-clean:
	$(RM) -fr target/pc88/obj
