$(eval $(call gfx_stamp_args,super80,TARGET=super80 FLAVOUR="gencon narrow"))
TOCREATE += $(call check_target,super80,super80_clib.lib super80_vduem_clib.lib)
super80_clib.lib: $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-super80 classic/gfx/obj/.stamp-super80
	@echo ''
	@echo '--- Building Super80 Library ---'
	@echo ''
	TARGET=super80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsuper80 -x$(OUTPUT_DIRECTORY)/super80_clib @$(TARGET_DIRECTORY)/super80/super80.lst

super80_vduem_clib.lib: $(TARGET_CLIB_DEPS) super80_clib.lib classic/games/obj/.stamp-super80 classic/gfx/obj/.stamp-super80
	@echo ''
	@echo '--- Building Super80 VDUEM Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6845 TARGET=super80
	TARGET=super80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsuper80 -x$(OUTPUT_DIRECTORY)/super80_vduem_clib @$(TARGET_DIRECTORY)/super80/super80_vduem.lst
