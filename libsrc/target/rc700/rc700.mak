RC700_GLOBS := \
	"target/rc700/*.asm" \
	"target/rc700/graphics/*.asm" \
	"target/rc700/time/*.asm" 

RC700_GLOBS_ex := \
	target/rc700/*.asm \
	target/rc700/graphics/*.asm \
	target/rc700/time/*.asm 


RC700_TARGETS := target/rc700/obj/target-rc700-rc700
		

CLEAN += target-rc700-clean

target-rc700: $(RC700_TARGETS)

.PHONY: target-rc700 target-rc700-clean


$(eval $(call buildtargetasm,target/rc700,z80,rc700,-mz80,$(RC700_GLOBS),$(RC700_GLOBS_ex)))

target-rc700-clean:
	$(RM) -fr target/rc700/obj
