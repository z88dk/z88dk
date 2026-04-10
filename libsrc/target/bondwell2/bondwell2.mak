BONDWELL2_GLOBS := \
	"target/bondwell2/graphics/*.asm" \
	"target/bondwell2/stdio/*.asm" 

BONDWELL2_GLOBS_ex := \
	target/bondwell2/graphics/*.asm \
	target/bondwell2/stdio/*.asm 


BONDWELL2_TARGETS := target/bondwell2/obj/target-bondwell2-bondwell2
		

CLEAN += target-bondwell2-clean

target-bondwell2: $(BONDWELL2_TARGETS)

.PHONY: target-bondwell2 target-bondwell2-clean


$(eval $(call buildtargetasm,target/bondwell2,z80,bondwell2,-mz80 -IXIY,$(BONDWELL2_GLOBS),$(BONDWELL2_GLOBS_ex)))

target-bondwell2-clean:
	$(RM) -fr target/bondwell2/obj
