AUSSIE_GLOBS := \
	"target/aussie/games/*.asm" \
	"target/aussie/graphics/*.asm"

AUSSIE_GLOBS_ex := \
	target/aussie/games/*.asm \
	target/aussie/graphics/*.asm


AUSSIE_TARGETS := target/aussie/obj/target-aussie-aussie


CLEAN += target-aussie-clean

target-aussie: $(AUSSIE_TARGETS)

.PHONY: target-aussie target-aussie-clean

$(eval $(call buildtargetasm,target/aussie,z80,aussie,-mz80,$(AUSSIE_GLOBS),$(AUSSIE_GLOBS_ex)))

target-aussie-clean:
	$(RM) -fr target/aussie/obj
