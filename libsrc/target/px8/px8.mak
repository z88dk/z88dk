PX8_GLOBS := \
	"target/px8/*.asm" \
	"target/px8/graphics/*.asm" \
	"target/px8/stdio/ansi/*.asm"

PX8_GLOBS_ex := \
	target/px8/*.asm \
	target/px8/graphics/*.asm \
	target/px8/stdio/ansi/*.asm


PX8_TARGETS := target/px8/obj/target-px8-px8


CLEAN += target-px8-clean

target-px8: $(PX8_TARGETS)

.PHONY: target-px8 target-px8-clean

$(eval $(call buildtargetasm,target/px8,z80,px8,-mz80,$(PX8_GLOBS),$(PX8_GLOBS_ex)))

target-px8-clean:
	$(RM) -fr target/px8/obj
