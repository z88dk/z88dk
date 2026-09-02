$(eval $(call gfx_stamp_args,nascom,TARGET=nascom FLAVOUR="gencon narrow"))
TOCREATE += $(call check_target,nascom,nascom_clib.lib nascomcpm.lib)

nascom_clib.lib: $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-nascom classic/gfx/obj/.stamp-nascom
	TARGET=nascom TYPE=z80 $(LIBLINKER) -DFORnascom -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/nascom_clib @$(TARGET_DIRECTORY)/nascom/nascom.lst
	@touch $@

nascomcpm.lib: $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-nascom classic/gfx/obj/.stamp-nascom
	TARGET=nascom TYPE=z80 $(LIBLINKER) -DFORnascom -DFORnascomcpm -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/nascomcpm @$(TARGET_DIRECTORY)/nascom/nascomcpm.lst
	@touch $@
