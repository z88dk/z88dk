GAL_GLOBS := \
	"target/gal/*.asm" \
	"target/gal/games/*.asm" \
	"target/gal/graphics/*.asm" \
	"target/gal/interrupt/*.asm" \
	"target/gal/psg/*.asm" \
	"target/gal/stdio/*.asm" \
	"target/gal/time/*.asm" 

GAL_GLOBS_ex := \
	target/gal/*.asm \
	target/gal/games/*.asm \
	target/gal/graphics/*.asm \
	target/gal/interrupt/*.asm \
	target/gal/psg/*.asm \
	target/gal/stdio/*.asm \
	target/gal/time/*.asm 


GAL_TARGETS := target/gal/obj/target-gal-gal
		

CLEAN += target-gal-clean

target-gal: $(GAL_TARGETS)

.PHONY: target-gal target-gal-clean


$(eval $(call buildtargetasm,target/gal,z80,gal,-mz80,$(GAL_GLOBS),$(GAL_GLOBS_ex)))

target-gal-clean:
	$(RM) -fr target/gal/obj
