MC1000_GLOBS := \
	"target/mc1000/games/*.asm" \
	"target/mc1000/graphics/*.asm" \
	"target/mc1000/interrupts/*.asm" \
	"target/mc1000/psg/*.asm" \
	"target/mc1000/stdio/*.asm" \
	"target/mc1000/time/*.asm" 

MC1000_GLOBS_ex := \
	target/mc1000/games/*.asm \
	target/mc1000/graphics/*.asm \
	target/mc1000/interrupts/*.asm \
	target/mc1000/psg/*.asm \
	target/mc1000/stdio/*.asm \
	target/mc1000/time/*.asm 


MC1000_TARGETS := target/mc1000/obj/target-mc1000-mc1000
		

CLEAN += target-mc1000-clean

target-mc1000: $(MC1000_TARGETS)

.PHONY: target-mc1000 target-mc1000-clean


$(eval $(call buildtargetasm,target/mc1000,z80,mc1000,-mz80,$(MC1000_GLOBS),$(MC1000_GLOBS_ex)))

target-mc1000-clean:
	$(RM) -fr target/mc1000/obj
