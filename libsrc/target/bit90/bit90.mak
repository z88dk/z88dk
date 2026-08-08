BIT90_GLOBS := \
	"target/bit90/games/*.asm"

BIT90_GLOBS_ex := \
	target/bit90/games/*.asm


BIT90_TARGETS := target/bit90/obj/target-bit90-bit90


CLEAN += target-bit90-clean

target-bit90: $(BIT90_TARGETS)

.PHONY: target-bit90 target-bit90-clean

$(eval $(call buildtargetasm,target/bit90,z80,bit90,-mz80,$(BIT90_GLOBS),$(BIT90_GLOBS_ex)))

target-bit90-clean:
	$(RM) -fr target/bit90/obj
