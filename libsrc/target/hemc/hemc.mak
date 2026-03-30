HEMC_GLOBS := \
	"target/hemc/stdio/*.asm" 

HEMC_GLOBS_ex := \
	target/hemc/stdio/*.asm 


HEMC_TARGETS := target/hemc/obj/target-hemc-hemc
		

CLEAN += target-hemc-clean

target-hemc: $(HEMC_TARGETS)

.PHONY: target-hemc target-hemc-clean


$(eval $(call buildtargetasm,target/hemc,z80,hemc,-mz80,$(HEMC_GLOBS),$(HEMC_GLOBS_ex)))

target-hemc-clean:
	$(RM) -fr target/hemc/obj
