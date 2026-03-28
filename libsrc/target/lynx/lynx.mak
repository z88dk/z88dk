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


LYNX_TARGETS := target/lynx/obj/target-lynx-lynx
		

CLEAN += target-lynx-clean

target-lynx: $(LYNX_TARGETS)

.PHONY: target-lynx target-lynx-clean


$(eval $(call buildtargetasm,target/lynx,z80,lynx,-mz80,$(LYNX_GLOBS),$(LYNX_GLOBS_ex)))

target-lynx-clean:
	$(RM) -fr target/lynx/obj
