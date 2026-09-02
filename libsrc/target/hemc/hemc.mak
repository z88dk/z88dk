HEMC_GLOBS := \
	"target/hemc/stdio/*.asm" 

HEMC_GLOBS_ex := \
	target/hemc/stdio/*.asm 


HEMC_TARGETS := target/hemc/obj/target-hemc-hemc classic/gfx/obj/.stamp-hemc
		

CLEAN += target-hemc-clean
hemc_clib.lib: $(TARGET_CLIB_DEPS) $(HEMC_TARGETS)
	@echo ''
	@echo '--- Building Hübler/Evert-MC Library ---'
	@echo ''
	TARGET=hemc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhemc -x$(OUTPUT_DIRECTORY)/hemc_clib @$(TARGET_DIRECTORY)/hemc/hemc.lst

TOCREATE += $(call check_target,hemc,hemc_clib.lib)

$(eval $(call gfx_stamp_args,hemc,TARGET=hemc FLAVOUR="gencon narrow"))

target-hemc: $(HEMC_TARGETS)

.PHONY: target-hemc target-hemc-clean


$(eval $(call buildtargetasm,target/hemc,z80,hemc,-mz80,$(HEMC_GLOBS),$(HEMC_GLOBS_ex)))

target-hemc-clean:
	$(RM) -fr target/hemc/obj
