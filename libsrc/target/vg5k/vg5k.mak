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

VG5K_TARGETS := target/vg5k/obj/target-vg5k-vg5k
		

CLEAN += target-vg5k-clean

target-vg5k: $(VG5K_TARGETS)

.PHONY: target-vg5k target-vg5k-clean


$(eval $(call buildtargetasm,target/vg5k,ixiy,vg5k,-mz80 -IXIY,$(VG5K_GLOBS),$(VG5K_GLOBS_ex)))

target-vg5k-clean:
	$(RM) -fr target/vg5k/obj
