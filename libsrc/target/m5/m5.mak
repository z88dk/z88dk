M5_GLOBS := \
	"target/m5/games/*.asm" \
	"target/m5/stdio/*.asm"

M5_GLOBS_ex := \
	target/m5/games/*.asm \
	target/m5/stdio/*.asm


M5_TARGETS := target/m5/obj/target-m5-m5


CLEAN += target-m5-clean

target-m5: $(M5_TARGETS)

.PHONY: target-m5 target-m5-clean

$(eval $(call buildtargetasm,target/m5,z80,m5,-mz80,$(M5_GLOBS),$(M5_GLOBS_ex)))

target-m5-clean:
	$(RM) -fr target/m5/obj
