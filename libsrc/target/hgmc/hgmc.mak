HGMC_GLOBS := \
	"target/hgmc/graphics/*.asm" \
	"target/hgmc/stdio/*.asm" 

HGMC_GLOBS_ex := \
	target/hgmc/graphics/*.asm \
	target/hgmc/stdio/*.asm 


HGMC_TARGETS := target/hgmc/obj/target-hgmc-hgmc classic/games/obj/.stamp-hgmc classic/gfx/obj/.stamp-hgmc
		

CLEAN += target-hgmc-clean
hgmc_clib.lib: $(TARGET_CLIB_DEPS) $(HGMC_TARGETS)
	@echo ''
	@echo '--- Building Hübler Grafik MC Library ---'
	@echo ''
	TARGET=hgmc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhgmc -x$(OUTPUT_DIRECTORY)/hgmc_clib @$(TARGET_DIRECTORY)/hgmc/hgmc.lst

TOCREATE += $(call check_target,hgmc,hgmc_clib.lib)

$(eval $(call gfx_stamp_args,hgmc,TARGET=hgmc))

target-hgmc: $(HGMC_TARGETS)

.PHONY: target-hgmc target-hgmc-clean


$(eval $(call buildtargetasm,target/hgmc,z80,hgmc,-mz80,$(HGMC_GLOBS),$(HGMC_GLOBS_ex)))

target-hgmc-clean:
	$(RM) -fr target/hgmc/obj
