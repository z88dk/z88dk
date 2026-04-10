ABC800_GLOBS := \
	"target/abc80/graphics/*.asm" \
	"target/abc800/abc800/*.asm" \
	"target/abc800/stdio/*.asm" 

ABC800_GLOBS_ex := \
	target/abc80/graphics/*.asm \
	target/abc800/abc800/*.asm \
	target/abc800/stdio/*.asm 


ABC800_TARGETS := target/abc800/obj/target-abc800-abc800
		

CLEAN += target-abc800-clean

target-abc800: $(ABC800_TARGETS)

.PHONY: target-abc800 target-abc800-clean


$(eval $(call buildtargetasm,target/abc800,z80,abc800,-mz80,$(ABC800_GLOBS),$(ABC800_GLOBS_ex)))

target-abc800-clean:
	$(RM) -fr target/abc800/obj
