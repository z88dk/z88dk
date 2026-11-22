KRAMERMC_GLOBS := \
	"target/kramermc/stdio/*.asm" 

KRAMERMC_GLOBS_ex := \
	target/kramermc/stdio/*.asm 


KRAMERMC_TARGETS := target/kramermc/obj/target-kramermc-kramermc classic/gfx/obj/.stamp-kramermc
		

CLEAN += target-kramermc-clean
TOCREATE += $(call check_target,kramermc,kramermc_clib.lib)
$(eval $(call gfx_stamp_args,kramermc,TARGET=kramermc FLAVOUR="gencon narrow"))
$(eval $(call buildtargetasm,target/kramermc,z80,kramermc,-mz80,$(KRAMERMC_GLOBS),$(KRAMERMC_GLOBS_ex)))

kramermc_clib.lib: $(TARGET_CLIB_DEPS) $(KRAMERMC_TARGETS)
	@echo ''
	@echo '--- Building Kramer-MC Library ---'
	@echo ''
	TARGET=kramermc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORkramermc -x$(OUTPUT_DIRECTORY)/kramermc_clib @$(TARGET_DIRECTORY)/kramermc/kramermc.lst



target-kramermc: $(KRAMERMC_TARGETS)

.PHONY: target-kramermc target-kramermc-clean



target-kramermc-clean:
	$(RM) -fr target/kramermc/obj
