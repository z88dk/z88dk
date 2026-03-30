Z9001_GLOBS := \
	"target/z9001/games/*.asm" \
	"target/z9001/graphics/*.asm" \
	"target/z9001/stdio/*.asm" \
	"target/z9001/stdio/ansi/*.asm" 

Z9001_GLOBS_ex := \
	target/z9001/games/*.asm \
	target/z9001/graphics/*.asm \
	target/z9001/stdio/*.asm \
	target/z9001/stdio/ansi/*.asm 


Z9001_TARGETS := target/z9001/obj/target-z9001-z9001
		

CLEAN += target-z9001-clean

target-z9001: $(Z9001_TARGETS)

.PHONY: target-z9001 target-z9001-clean


$(eval $(call buildtargetasm,target/z9001,z80,z9001,-mz80,$(Z9001_GLOBS),$(Z9001_GLOBS_ex)))

target-z9001-clean:
	$(RM) -fr target/z9001/obj
