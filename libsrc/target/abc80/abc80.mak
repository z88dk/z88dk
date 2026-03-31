ABC80_GLOBS := \
	"target/abc80/abc80/*.asm" \
	"target/abc80/graphics/*.asm" \
	"target/abc80/stdio/*.asm" \
	"target/abc80/stdio/ansi/*.asm" \
	"target/abc80/time/*.asm" 

ABC80_GLOBS_ex := \
	target/abc80/abc80/*.asm \
	target/abc80/graphics/*.asm \
	target/abc80/stdio/*.asm \
	target/abc80/stdio/ansi/*.asm \
	target/abc80/time/*.asm 


ABC80_TARGETS := target/abc80/obj/target-abc80-abc80
		

CLEAN += target-abc80-clean

target-abc80: $(ABC80_TARGETS)

.PHONY: target-abc80 target-abc80-clean


$(eval $(call buildtargetasm,target/abc80,z80,abc80,-mz80,$(ABC80_GLOBS),$(ABC80_GLOBS_ex)))

target-abc80-clean:
	$(RM) -fr target/abc80/obj
