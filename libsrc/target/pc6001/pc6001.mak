PC6001_GLOBS := \
	"target/pc6001/games/*.asm" \
	"target/pc6001/graphics/*.asm" \
	"target/pc6001/psg/*.asm" \
	"target/pc6001/stdio/*.asm" \
	"target/pc6001/stdio/ansi/*.asm" 

PC6001_GLOBS_ex := \
	target/pc6001/games/*.asm \
	target/pc6001/graphics/*.asm \
	target/pc6001/psg/*.asm \
	target/pc6001/stdio/*.asm \
	target/pc6001/stdio/ansi/*.asm 


PC6001_TARGETS := target/pc6001/obj/target-pc6001-pc6001 classic/games/obj/.stamp-pc6001 classic/gfx/obj/.stamp-pc6001

pc6001_clib.lib: $(TARGET_CLIB_DEPS) $(PC6001_TARGETS)
	$(MAKE) -C classic/video/mc6847 TARGET=pc6001
	TARGET=pc6001 TYPE=z80 $(LIBLINKER) -DFORpc6001 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc6001_clib @$(TARGET_DIRECTORY)/pc6001/pc6001.lst

$(eval $(call gfx_stamp_portable_args,pc6001,TARGET=pc6001 FLAVOUR=narrow))
		

CLEAN += target-pc6001-clean
TOCREATE += $(call check_target,pc6001,pc6001_clib.lib)

target-pc6001: $(PC6001_TARGETS)

.PHONY: target-pc6001 target-pc6001-clean


$(eval $(call buildtargetasm,target/pc6001,z80,pc6001,-mz80,$(PC6001_GLOBS),$(PC6001_GLOBS_ex)))

target-pc6001-clean:
	$(RM) -fr target/pc6001/obj
