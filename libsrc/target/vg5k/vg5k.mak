VG5K_GLOBS := \
	"target/vg5k/games/*.asm" \
	"target/vg5k/graphics/*.asm" \
	"target/vg5k/input/*.asm" \
	"target/vg5k/interrupts/*.asm" \
	"target/vg5k/stdio/*.asm" \
	"target/vg5k/stdio/ansi/*.asm" 

VG5K_GLOBS_ex := \
	target/vg5k/games/*.asm \
	target/vg5k/graphics/*.asm \
	target/vg5k/input/*.asm \
	target/vg5k/interrupts/*.asm \
	target/vg5k/stdio/*.asm \
	target/vg5k/stdio/ansi/*.asm 

VG5K_TARGETS := target/vg5k/obj/target-vg5k-vg5k classic/games/obj/.stamp-vg5k classic/gfx/obj/.stamp-vg5k
		

CLEAN += target-vg5k-clean
TOCREATE += $(call check_target,vg5k,vg5k_clib.lib)

$(eval $(call gfx_stamp_args,vg5k,TARGET=vg5k FLAVOUR="gencon narrow"))
$(eval $(call buildtargetasm,target/vg5k,ixiy,vg5k,-mz80 -IXIY,$(VG5K_GLOBS),$(VG5K_GLOBS_ex)))

vg5k_clib.lib: $(TARGET_CLIB_DEPS) $(VG5K_TARGETS)
	TARGET=vg5k TYPE=ixiy $(LIBLINKER) -IXIY -DFORvg5k -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/vg5k_clib @$(TARGET_DIRECTORY)/vg5k/vg5k.lst


target-vg5k: $(VG5K_TARGETS)

.PHONY: target-vg5k target-vg5k-clean



target-vg5k-clean:
	$(RM) -fr target/vg5k/obj
