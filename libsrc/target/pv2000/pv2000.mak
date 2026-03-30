PV2000_GLOBS := \
	"target/pv2000/input/*.asm" 

PV2000_GLOBS_ex := \
	target/pv2000/input/*.asm 


PV2000_TARGETS := target/pv2000/obj/target-pv2000-pv2000
		

CLEAN += target-pv2000-clean

target-pv2000: $(PV2000_TARGETS)

.PHONY: target-pv2000 target-pv2000-clean


$(eval $(call buildtargetasm,target/pv2000,z80,pv2000,-mz80,$(PV2000_GLOBS),$(PV2000_GLOBS_ex)))

target-pv2000-clean:
	$(RM) -fr target/pv2000/obj
