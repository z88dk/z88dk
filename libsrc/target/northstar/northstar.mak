NORTHSTAR_GLOBS := \
	"target/northstar/graphics/*.asm"

NORTHSTAR_GLOBS_ex := \
	target/northstar/graphics/*.asm


NORTHSTAR_TARGETS := target/northstar/obj/target-northstar-northstar


CLEAN += target-northstar-clean

target-northstar: $(NORTHSTAR_TARGETS)

.PHONY: target-northstar target-northstar-clean

$(eval $(call buildtargetasm,target/northstar,z80,northstar,-mz80,$(NORTHSTAR_GLOBS),$(NORTHSTAR_GLOBS_ex)))

target-northstar-clean:
	$(RM) -fr target/northstar/obj
