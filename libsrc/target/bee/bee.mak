$(eval $(call gfx_stamp_args,bee,TARGET=bee FLAVOUR="gencon narrow"))
$(eval $(call gfx_stamp_args,bee-cpm,TARGET=bee FLAVOUR="gencon text6 narrow"))
$(eval $(call gfx_stamp_args,bee-hr,TARGET=bee FLAVOUR=wide SUBTYPE=beehr))
$(eval $(call gfx_stamp_args,bee-hr320,TARGET=bee FLAVOUR=wide SUBTYPE=beehr320))
$(eval $(call gfx_stamp_args,bee-hr512,TARGET=bee FLAVOUR=wide SUBTYPE=beehr512))
TOCREATE += $(call check_target,bee,bee_clib.lib microbee.lib $(CPMLIBS) gfxbee.lib gfxbee640.lib gfxbee320.lib gfxbee512.lib)
bee_clib.lib: $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee
	@echo ''
	@echo '--- Building MicroBee Library ---'
	@echo ''
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/bee_clib.lib @$(TARGET_DIRECTORY)/bee/bee.lst

microbee.lib:  cpm_clib.lib bee_clib.lib classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee-cpm classic/gfx/obj/.stamp-bee-hr classic/gfx/obj/.stamp-bee-hr320 classic/gfx/obj/.stamp-bee-hr512
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/microbee.lib @$(TARGET_DIRECTORY)/bee/beecpm.lst
	@touch $@

gfxbee.lib:  cpm_clib.lib bee_clib.lib classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee-cpm classic/gfx/obj/.stamp-bee-hr classic/gfx/obj/.stamp-bee-hr320 classic/gfx/obj/.stamp-bee-hr512
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -x$(OUTPUT_DIRECTORY)/gfxbee.lib @$(TARGET_DIRECTORY)/bee/beegfx.lst
	@touch $@

gfxbee640.lib:  gfxbee.lib cpm_clib.lib bee_clib.lib classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee-cpm classic/gfx/obj/.stamp-bee-hr classic/gfx/obj/.stamp-bee-hr320 classic/gfx/obj/.stamp-bee-hr512
	TARGET=beehr TYPE=z80 $(LIBLINKER) -DFORbeehr -x$(OUTPUT_DIRECTORY)/gfxbee640.lib @$(TARGET_DIRECTORY)/bee/beegfxhr.lst
	@touch $@

gfxbee320.lib:  gfxbee640.lib cpm_clib.lib bee_clib.lib classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee-cpm classic/gfx/obj/.stamp-bee-hr classic/gfx/obj/.stamp-bee-hr320 classic/gfx/obj/.stamp-bee-hr512
	TARGET=beehr320 TYPE=z80 $(LIBLINKER) -DFORbeehr320 -x$(OUTPUT_DIRECTORY)/gfxbee320.lib @$(TARGET_DIRECTORY)/bee/beegfxhr320.lst
	@touch $@

gfxbee512.lib:  gfxbee320.lib cpm_clib.lib bee_clib.lib classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee-cpm classic/gfx/obj/.stamp-bee-hr classic/gfx/obj/.stamp-bee-hr320 classic/gfx/obj/.stamp-bee-hr512
	TARGET=beehr512 TYPE=z80 $(LIBLINKER) -DFORbeehr512 -x$(OUTPUT_DIRECTORY)/gfxbee512.lib @$(TARGET_DIRECTORY)/bee/beegfxhr512.lst
	@touch $@
