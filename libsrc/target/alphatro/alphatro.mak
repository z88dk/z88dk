ALPHATRO_MC6845_SOURCES := $(wildcard classic/video/mc6845/*.asm)
ALPHATRO_MC6845_OBJECTS := $(patsubst classic/video/mc6845/%.asm,classic/video/mc6845/obj/alphatro/%.o,$(ALPHATRO_MC6845_SOURCES))

$(eval $(call gfx_stamp_args,alphatro,TARGET=alphatro FLAVOUR="gencon narrow"))
TOCREATE += $(call check_target,alphatro,alphatro_clib.lib alphatro_cpm.lib)

$(ALPHATRO_MC6845_OBJECTS): classic/video/mc6845/obj/alphatro/%.o: classic/video/mc6845/%.asm
	$(Q)mkdir -p $(@D)
	$(Q)$(ASSEMBLER) -DFORalphatro -Iclassic/video/mc6845 -o=$@ $<

alphatro_clib.lib:  $(TARGET_CLIB_DEPS) $(ALPHATRO_MC6845_OBJECTS) classic/games/obj/.stamp-alphatro classic/gfx/obj/.stamp-alphatro
	TARGET=alphatro TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORalphatro -x$(OUTPUT_DIRECTORY)/alphatro_clib @$(TARGET_DIRECTORY)/alphatro/alphatro.lst
	@touch $@

alphatro_cpm.lib:  alphatro_clib.lib $(TARGET_CLIB_DEPS) $(ALPHATRO_MC6845_OBJECTS) classic/games/obj/.stamp-alphatro classic/gfx/obj/.stamp-alphatro
	TARGET=alphatro TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORalphatro -x$(OUTPUT_DIRECTORY)/alphatro_cpm @$(TARGET_DIRECTORY)/alphatro/alphatro_cpm.lst
	@touch $@
