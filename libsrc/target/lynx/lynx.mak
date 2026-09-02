LYNX_GLOBS := \
	"target/lynx/*.asm" \
	"target/lynx/games/*.asm" \
	"target/lynx/graphics/*.asm" \
	"target/lynx/input/*.asm" \
	"target/lynx/stdio/*.asm" 

LYNX_GLOBS_ex := \
	target/lynx/*.asm \
	target/lynx/games/*.asm \
	target/lynx/graphics/*.asm \
	target/lynx/input/*.asm \
	target/lynx/stdio/*.asm 


LYNX_TARGETS := target/lynx/obj/target-lynx-lynx classic/games/obj/.stamp-lynx classic/gfx/obj/.stamp-lynx
		

CLEAN += target-lynx-clean
TOCREATE += $(call check_target,lynx,lynx_clib.lib)

lynx_clib.lib: $(TARGET_CLIB_DEPS) $(LYNX_TARGETS)
	$(MAKE) -C classic/video/mc6845 TARGET=lynx
	TARGET=lynx TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORlynx -x$(OUTPUT_DIRECTORY)/lynx_clib @$(TARGET_DIRECTORY)/lynx/lynx.lst

$(eval $(call gfx_stamp_args,lynx,TARGET=lynx FLAVOUR="gencon narrow"))

target-lynx: $(LYNX_TARGETS)

.PHONY: target-lynx target-lynx-clean


$(eval $(call buildtargetasm,target/lynx,z80,lynx,-mz80,$(LYNX_GLOBS),$(LYNX_GLOBS_ex)))

target-lynx-clean:
	$(RM) -fr target/lynx/obj
