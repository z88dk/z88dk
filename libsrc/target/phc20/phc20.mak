$(eval $(call gfx_stamp_args,phc20,TARGET=phc20))
TOCREATE += $(call check_target,phc20,phc20_clib.lib)

phc20_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-phc20
	$(MAKE) -C classic/video/mc6847 TARGET=phc20
	TARGET=phc20 TYPE=z80 $(LIBLINKER) -DFORphc20 -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/phc20_clib @$(TARGET_DIRECTORY)/phc20/phc20.lst
