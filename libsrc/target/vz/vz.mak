VZ_GLOBS := \
	"target/vz/games/*.asm" \
	"target/vz/graphics/*.asm" \
	"target/vz/*.asm" \
	"target/vz/input/*.asm" \
	"target/vz/stdio/*.asm" \
	"target/vz/stdio/ansi/*.asm" 

VZ_GLOBS_ex := \
	target/vz/games/*.asm \
	target/vz/graphics/*.asm \
	target/vz/*.asm \
	target/vz/input/*.asm \
	target/vz/stdio/*.asm \
	target/vz/stdio/ansi/*.asm 


VZ_TARGETS := target/vz/obj/target-vz-vz
		

CLEAN += target-vz-clean

target-vz: $(VZ_TARGETS)

.PHONY: target-vz target-vz-clean


$(eval $(call buildtargetasm,target/vz,z80,vz,-mz80,$(VZ_GLOBS),$(VZ_GLOBS_ex)))

target-vz-clean:
	$(RM) -fr target/vz/obj
