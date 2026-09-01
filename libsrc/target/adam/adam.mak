ADAM_GLOBS := \
	"target/adam/*.asm"

ADAM_GLOBS_ex := \
	target/adam/*.asm


ADAM_TARGETS := target/adam/obj/target-adam-adam classic/games/obj/.stamp-cpm-coleco classic/gfx/obj/.stamp-cpm-coleco


CLEAN += target-adam-clean

target-adam: $(ADAM_TARGETS)

.PHONY: target-adam target-adam-clean

$(eval $(call buildtargetasm,target/adam,z80,adam,-mz80,$(ADAM_GLOBS),$(ADAM_GLOBS_ex)))

target-adam-clean:
	$(RM) -fr target/adam/obj
