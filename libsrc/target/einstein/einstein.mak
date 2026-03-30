EINSTEIN_GLOBS := \
	"target/einstein/psg/*.asm" \
	"target/einstein/stdio/*.asm" 

EINSTEIN_GLOBS_ex := \
	target/einstein/psg/*.asm \
	target/einstein/stdio/*.asm 


EINSTEIN_TARGETS := target/einstein/obj/target-einstein-einstein
		

CLEAN += target-einstein-clean

target-einstein: $(EINSTEIN_TARGETS)

.PHONY: target-einstein target-einstein-clean


$(eval $(call buildtargetasm,target/einstein,z80,einstein,-mz80,$(EINSTEIN_GLOBS),$(EINSTEIN_GLOBS_ex)))

target-einstein-clean:
	$(RM) -fr target/einstein/obj
