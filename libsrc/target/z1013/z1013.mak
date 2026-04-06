Z1013_GLOBS := \
	"target/z1013/games/*.asm" \
	"target/z1013/graphics/*.asm" \
	"target/z1013/stdio/*.asm" \
	"target/z1013/stdio/ansi/*.asm" 

Z1013_GLOBS_ex := \
	target/z1013/games/*.asm \
	target/z1013/graphics/*.asm \
	target/z1013/stdio/*.asm \
	target/z1013/stdio/ansi/*.asm 


Z1013_TARGETS := target/z1013/obj/target-z1013-z1013
		

CLEAN += target-z1013-clean

target-z1013: $(Z1013_TARGETS)

.PHONY: target-z1013 target-z1013-clean


$(eval $(call buildtargetasm,target/z1013,z80,z1013,-mz80,$(Z1013_GLOBS),$(Z1013_GLOBS_ex)))

target-z1013-clean:
	$(RM) -fr target/z1013/obj
