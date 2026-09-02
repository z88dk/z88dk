$(eval $(call gfx_stamp_args,smc777,TARGET=smc777 FLAVOUR=wide))
TOCREATE += $(call check_target,smc777,smc777_clib.lib smc777_cpm.lib $(CPMLIBS))

smc777_clib.lib: $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-smc777 classic/gfx/obj/.stamp-smc777
	$(MAKE) -C classic/video/mc6845 TARGET=smc777
	TARGET=smc777 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsmc777 -x$(OUTPUT_DIRECTORY)/smc777_clib @$(TARGET_DIRECTORY)/smc777/smc777.lst

smc777_cpm.lib: smc777_clib.lib classic/games/obj/.stamp-cpm-smc777 classic/gfx/obj/.stamp-cpm-smc777
	$(MAKE) -C classic/video/mc6845 TARGET=smc777
	TARGET=smc777 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsmc777 -x$(OUTPUT_DIRECTORY)/smc777_cpm @$(TARGET_DIRECTORY)/smc777/smc777_cpm.lst
