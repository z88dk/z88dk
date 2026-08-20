X820_GLOBS := \
	"target/x820/graphics/*.asm" \
	"target/x820/stdio/*.asm"

X820_GLOBS_ex := \
	target/x820/graphics/*.asm \
	target/x820/stdio/*.asm


X820_TARGETS := target/x820/obj/target-x820-x820


CLEAN += target-x820-clean

target-x820: $(X820_TARGETS)

.PHONY: target-x820 target-x820-clean

$(eval $(call buildtargetasm,target/x820,z80,x820,-mz80,$(X820_GLOBS),$(X820_GLOBS_ex)))

target-x820-clean:
	$(RM) -fr target/x820/obj
