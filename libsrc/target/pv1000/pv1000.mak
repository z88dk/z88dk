PV1000_GLOBS := \
	"target/pv1000/games/*.asm" \
	"target/pv1000/graphics/*.asm" \
	"target/pv1000/stdio/*.asm" 

PV1000_GLOBS_ex := \
	target/pv1000/games/*.asm \
	target/pv1000/graphics/*.asm \
	target/pv1000/stdio/*.asm 


PV1000_TARGETS := target/pv1000/obj/target-pv1000-pv1000
		

CLEAN += target-pv1000-clean

target-pv1000: $(PV1000_TARGETS)

.PHONY: target-pv1000 target-pv1000-clean


$(eval $(call buildtargetasm,target/pv1000,z80,pv1000,-mz80,$(PV1000_GLOBS),$(PV1000_GLOBS_ex)))

target-pv1000-clean:
	$(RM) -fr target/pv1000/obj
