RADIO86_GLOBS := \
	"target/radio86/graphics/*.asm" \
	"target/radio86/stdio/*.asm" 

RADIO86_GLOBS_ex := \
	target/radio86/graphics/*.asm \
	target/radio86/stdio/*.asm 


RADIO86_TARGETS := target/radio86/obj/target-radio86-radio86
		

CLEAN += target-radio86-clean

target-radio86: $(RADIO86_TARGETS)

.PHONY: target-radio86 target-radio86-clean


$(eval $(call buildtargetasm,target/radio86,8080,radio86,-m8080,$(RADIO86_GLOBS),$(RADIO86_GLOBS_ex)))

target-radio86-clean:
	$(RM) -fr target/radio86/obj
