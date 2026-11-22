$(eval $(call gfx_stamp_args,phc20,TARGET=phc20))
PHC20_TARGETS := classic/video/mc6847/obj/phc20
$(eval $(call buildvideo,mc6847,MC6847,phc20,))
TOCREATE += $(call check_target,phc20,phc20_clib.lib)

phc20_clib.lib: $(TARGET_CLIB_DEPS) $(PHC20_TARGETS) classic/gfx/obj/.stamp-phc20
	TARGET=phc20 TYPE=z80 $(LIBLINKER) -DFORphc20 -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/phc20_clib @$(TARGET_DIRECTORY)/phc20/phc20.lst
