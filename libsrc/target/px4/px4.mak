PX4_GLOBS := \
	"target/px4/graphics/*.asm" \
	"target/px4/stdio/ansi/*.asm"

PX4_GLOBS_ex := \
	target/px4/graphics/*.asm \
	target/px4/stdio/ansi/*.asm


PX4_TARGETS := target/px4/obj/target-px4-px4


CLEAN += target-px4-clean

target-px4: $(PX4_TARGETS)

.PHONY: target-px4 target-px4-clean

$(eval $(call buildtargetasm,target/px4,z80,px4,-mz80,$(PX4_GLOBS),$(PX4_GLOBS_ex)))

target-px4-clean:
	$(RM) -fr target/px4/obj
