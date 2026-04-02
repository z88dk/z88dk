TIM011_GLOBS := \
	"target/tim011/graphics/*.asm" \
	"target/tim011/stdio/*.asm" 

TIM011_GLOBS_ex := \
	target/tim011/graphics/*.asm \
	target/tim011/stdio/*.asm 


TIM011_TARGETS := target/tim011/obj/target-tim011-tim011
		

CLEAN += target-tim011-clean

target-tim011: $(TIM011_TARGETS)

.PHONY: target-tim011 target-tim011-clean


$(eval $(call buildtargetasm,target/tim011,z180,tim011,-mz180,$(TIM011_GLOBS),$(TIM011_GLOBS_ex)))

target-tim011-clean:
	$(RM) -fr target/tim011/obj
