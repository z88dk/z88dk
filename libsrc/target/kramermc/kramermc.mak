KRAMERMC_GLOBS := \
	"target/kramermc/stdio/*.asm" 

KRAMERMC_GLOBS_ex := \
	target/kramermc/stdio/*.asm 


KRAMERMC_TARGETS := target/kramermc/obj/target-kramermc-kramermc
		

CLEAN += target-kramermc-clean

target-kramermc: $(KRAMERMC_TARGETS)

.PHONY: target-kramermc target-kramermc-clean


$(eval $(call buildtargetasm,target/kramermc,z80,kramermc,-mz80,$(KRAMERMC_GLOBS),$(KRAMERMC_GLOBS_ex)))

target-kramermc-clean:
	$(RM) -fr target/kramermc/obj
