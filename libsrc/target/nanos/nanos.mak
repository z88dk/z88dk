NANOS_GLOBS := \
	"target/nanos/graphics/*.asm" \
	"target/nanos/stdio/*.asm" 

NANOS_GLOBS_ex := \
	target/nanos/graphics/*.asm \
	target/nanos/stdio/*.asm 


NANOS_TARGETS := target/nanos/obj/target-nanos-nanos
		

CLEAN += target-nanos-clean

target-nanos: $(NANOS_TARGETS)

.PHONY: target-nanos target-nanos-clean


$(eval $(call buildtargetasm,target/nanos,z80,nanos,-mz80,$(NANOS_GLOBS),$(NANOS_GLOBS_ex)))

target-nanos-clean:
	$(RM) -fr target/nanos/obj
