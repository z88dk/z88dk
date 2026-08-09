OSBORNE1_GLOBS := \
	"target/osborne1/graphics/*.asm"

OSBORNE1_GLOBS_ex := \
	target/osborne1/graphics/*.asm


OSBORNE1_TARGETS := target/osborne1/obj/target-osborne1-osborne1


CLEAN += target-osborne1-clean

target-osborne1: $(OSBORNE1_TARGETS)

.PHONY: target-osborne1 target-osborne1-clean

$(eval $(call buildtargetasm,target/osborne1,z80,osborne1,-mz80,$(OSBORNE1_GLOBS),$(OSBORNE1_GLOBS_ex)))

target-osborne1-clean:
	$(RM) -fr target/osborne1/obj
