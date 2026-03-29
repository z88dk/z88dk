RX78_GLOBS := \
	"target/rx78/*.asm" \
	"target/rx78/games/*.asm" \
	"target/rx78/graphics/*.asm" \
	"target/rx78/input/*.asm" \
	"target/rx78/stdio/*.asm" 

RX78_GLOBS_ex := \
	target/rx78/*.asm \
	target/rx78/games/*.asm \
	target/rx78/graphics/*.asm \
	target/rx78/input/*.asm \
	target/rx78/stdio/*.asm 


RX78_TARGETS := target/rx78/obj/target-rx78-rx78
		

CLEAN += target-rx78-clean

target-rx78: $(RX78_TARGETS)

.PHONY: target-rx78 target-rx78-clean


$(eval $(call buildtargetasm,target/rx78,z80,rx78,-mz80,$(RX78_GLOBS),$(RX78_GLOBS_ex)))

target-rx78-clean:
	$(RM) -fr target/rx78/obj
