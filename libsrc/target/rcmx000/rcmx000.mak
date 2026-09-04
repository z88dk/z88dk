$(eval $(call gfx_stamp_args,rcmx000,TARGET=rcmx000))
TOCREATE += $(call check_target,rcmx000,rcmx000_clib.lib)
rcmx000_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-rcmx000
	@echo ''
	@echo '--- Building RCM2/3000 Library ---'
	@echo ''
	TARGET=rcmx000 TYPE=r2ka $(LIBLINKER) -mr2ka -DSTANDARDESCAPECHARS -DFORrcmx000 -x$(OUTPUT_DIRECTORY)/rcmx000_clib @$(TARGET_DIRECTORY)/rcmx000/rcmx000.lst
