$(eval $(call gfx_stamp_args,embedded,TARGET=embedded))
TOCREATE += $(call check_target,embedded,embedded_clib.lib)
embedded_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-embedded
	@echo ''
	@echo '--- Building Embedded (ns16450) Library ---'
	@echo ''
	TARGET=embedded TYPE=z80 $(LIBLINKER) -DFORembedded -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/embedded_clib @$(TARGET_DIRECTORY)/embedded/embedded.lst
