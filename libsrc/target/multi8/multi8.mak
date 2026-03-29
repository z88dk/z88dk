MULTI8_GLOBS := \
	"target/multi8/graphics/*.asm" \
	"target/multi8/*.asm" \
	"target/multi8/psg/*.asm" \
	"target/multi8/stdio/*.asm" 

MULTI8_GLOBS_ex := \
	target/multi8/graphics/*.asm \
	target/multi8/*.asm \
	target/multi8/psg/*.asm \
	target/multi8/stdio/*.asm 


MULTI8_TARGETS := target/multi8/obj/target-multi8-multi8
		

CLEAN += target-multi8-clean

target-multi8: $(MULTI8_TARGETS)

.PHONY: target-multi8 target-multi8-clean


$(eval $(call buildtargetasm,target/multi8,z80,multi8,-mz80,$(MULTI8_GLOBS),$(MULTI8_GLOBS_ex)))

target-multi8-clean:
	$(RM) -fr target/multi8/obj
