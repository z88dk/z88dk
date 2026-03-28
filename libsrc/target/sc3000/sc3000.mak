SC3000_GLOBS := \
	"target/sc3000/games/*.asm" \
	"target/sc3000/input/*.asm" \
	"target/sc3000/stdio/*.asm" \
	"target/sc3000/time/*.asm" 

SC3000_GLOBS_ex := \
	target/sc3000/games/*.asm \
	target/sc3000/input/*.asm \
	target/sc3000/stdio/*.asm \
	target/sc3000/time/*.asm 


SC3000_TARGETS := target/sc3000/obj/target-sc3000-sc3000
		

CLEAN += target-sc3000-clean

target-sc3000: $(SC3000_TARGETS)

.PHONY: target-sc3000 target-sc3000-clean


$(eval $(call buildtargetasm,target/sc3000,z80,sc3000,-mz80,$(SC3000_GLOBS),$(SC3000_GLOBS_ex)))

target-sc3000-clean:
	$(RM) -fr target/sc3000/obj
