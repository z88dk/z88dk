DAI_GLOBS := \
	"target/dai/stdio/*.asm" 

DAI_GLOBS_ex := \
	target/dai/stdio/*.asm 


DAI_TARGETS := target/dai/obj/target-dai-dai classic/gfx/obj/.stamp-dai
		

CLEAN += target-dai-clean
dai_clib.lib: $(TARGET_CLIB_DEPS) $(DAI_TARGETS)
	@echo ''
	@echo '--- Building DAI Library ---'
	@echo ''
	TARGET=dai TYPE=8080 $(LIBLINKER) -m8080 -DFORdai -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/dai_clib @$(TARGET_DIRECTORY)/dai/dai.lst

TOCREATE += $(call check_target,dai,dai_clib.lib)

$(eval $(call gfx_stamp_portable,dai,dai))

target-dai: $(DAI_TARGETS)

.PHONY: target-dai target-dai-clean


$(eval $(call buildtargetasm,target/dai,8080,dai,-m8080,$(DAI_GLOBS),$(DAI_GLOBS_ex)))

target-dai-clean:
	$(RM) -fr target/dai/obj
