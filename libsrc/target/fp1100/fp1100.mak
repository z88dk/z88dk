$(eval $(call gfx_stamp_args,fp1100,TARGET=fp1100 FLAVOUR=wide))
TOCREATE += $(call check_target,fp1100,fp1100_clib.lib fp1100_cpm.lib)
fp1100_clib.lib:  $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-cpm-fp1100 classic/gfx/obj/.stamp-fp1100
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_clib @$(TARGET_DIRECTORY)/fp1100/fp1100.lst
	@touch $@

fp1100_cpm.lib:  fp1100_clib.lib $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-cpm-fp1100 classic/gfx/obj/.stamp-fp1100
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_cpm @$(TARGET_DIRECTORY)/fp1100/fp1100_cpm.lst
	@touch $@
