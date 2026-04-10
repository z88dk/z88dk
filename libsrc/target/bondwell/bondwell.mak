BONDWELL_GLOBS := \
	"target/bondwell/graphics/*.asm" \
	"target/bondwell/stdio/*.asm" 

BONDWELL_GLOBS_ex := \
	target/bondwell/graphics/*.asm \
	target/bondwell/stdio/*.asm 


BONDWELL_TARGETS := target/bondwell/obj/target-bondwell-bondwell
		

CLEAN += target-bondwell-clean

target-bondwell: $(BONDWELL_TARGETS)

.PHONY: target-bondwell target-bondwell-clean


$(eval $(call buildtargetasm,target/bondwell,z80,bondwell,-mz80,$(BONDWELL_GLOBS),$(BONDWELL_GLOBS_ex)))

target-bondwell-clean:
	$(RM) -fr target/bondwell/obj
