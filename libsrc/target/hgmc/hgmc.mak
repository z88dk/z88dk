HGMC_GLOBS := \
	"target/hgmc/graphics/*.asm" \
	"target/hgmc/stdio/*.asm" 

HGMC_GLOBS_ex := \
	target/hgmc/graphics/*.asm \
	target/hgmc/stdio/*.asm 


HGMC_TARGETS := target/hgmc/obj/target-hgmc-hgmc
		

CLEAN += target-hgmc-clean

target-hgmc: $(HGMC_TARGETS)

.PHONY: target-hgmc target-hgmc-clean


$(eval $(call buildtargetasm,target/hgmc,z80,hgmc,-mz80,$(HGMC_GLOBS),$(HGMC_GLOBS_ex)))

target-hgmc-clean:
	$(RM) -fr target/hgmc/obj
