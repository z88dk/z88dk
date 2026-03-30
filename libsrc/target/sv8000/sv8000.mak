SV8000_GLOBS := \
	"target/sv8000/games/*.asm" \
	"target/sv8000/interrupts/*.asm" \
	"target/sv8000/psg/*.asm" 

SV8000_GLOBS_ex := \
	target/sv8000/games/*.asm \
	target/sv8000/interrupts/*.asm \
	target/sv8000/psg/*.asm 


SV8000_TARGETS := target/sv8000/obj/target-sv8000-sv8000
		

CLEAN += target-sv8000-clean

target-sv8000: $(SV8000_TARGETS)

.PHONY: target-sv8000 target-sv8000-clean


$(eval $(call buildtargetasm,target/sv8000,z80,sv8000,-mz80,$(SV8000_GLOBS),$(SV8000_GLOBS_ex)))

target-sv8000-clean:
	$(RM) -fr target/sv8000/obj
