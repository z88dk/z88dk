PC6001_GLOBS := \
	"target/pc6001/games/*.asm" \
	"target/pc6001/graphics/*.asm" \
	"target/pc6001/mk2/*.asm" \
	"target/pc6001/mk2stubs/*.asm" \
	"target/pc6001/psg/*.asm" \
	"target/pc6001/stdio/*.asm" \
	"target/pc6001/stdio/ansi/*.asm" 

PC6001_GLOBS_ex := \
	target/pc6001/games/*.asm \
	target/pc6001/graphics/*.asm \
	target/pc6001/mk2/*.asm \
	target/pc6001/mk2stubs/*.asm \
	target/pc6001/psg/*.asm \
	target/pc6001/stdio/*.asm \
	target/pc6001/stdio/ansi/*.asm 


PC6001_TARGETS := target/pc6001/obj/target-pc6001-pc6001 classic/video/mc6847/obj/pc6001 classic/games/obj/.stamp-pc6001 classic/gfx/obj/.stamp-pc6001
PC6001MK2_TARGETS := target/pc6001/obj/target-pc6001-pc6001 classic/gfx/obj/.stamp-pc6001mk2

$(eval $(call gfx_stamp_portable_args,pc6001,TARGET=pc6001 FLAVOUR=narrow))
$(eval $(call gfx_stamp_args,pc6001mk2,TARGET=pc6001 SUBTYPE=pc6001mk2 FLAVOUR=wide))
$(eval $(call buildvideo,mc6847,MC6847,pc6001,))
CLEAN += target-pc6001-clean
TOCREATE += $(call check_target,pc6001,pc6001_clib.lib pc6001mk2.lib)
$(eval $(call buildtargetasm,target/pc6001,z80,pc6001,-mz80,$(PC6001_GLOBS),$(PC6001_GLOBS_ex)))

pc6001_clib.lib: $(TARGET_CLIB_DEPS) $(PC6001_TARGETS)
	TARGET=pc6001 TYPE=z80 $(LIBLINKER) -DFORpc6001 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc6001_clib @$(TARGET_DIRECTORY)/pc6001/pc6001.lst

		


# The mkII's part: linked before pc6001_clib.lib (lib/config/pc6001.cfg, -clib=mk2disc)
pc6001mk2.lib: pc6001_clib.lib $(TARGET_CLIB_DEPS) $(PC6001MK2_TARGETS) target/pc6001/pc6001mk2.lst
	TARGET=pc6001mk2 TYPE=z80 $(LIBLINKER) -DFORpc6001 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc6001mk2 @$(TARGET_DIRECTORY)/pc6001/pc6001mk2.lst
	@touch $@

target-pc6001: $(PC6001_TARGETS)

.PHONY: target-pc6001 target-pc6001-clean



target-pc6001-clean:
	$(RM) -fr target/pc6001/obj
