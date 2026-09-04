EXCALI64_MC6845_SOURCES := $(wildcard classic/video/mc6845/*.asm)
EXCALI64_MC6845_OBJECTS := $(patsubst classic/video/mc6845/%.asm,classic/video/mc6845/obj/excali64/%.o,$(EXCALI64_MC6845_SOURCES))

$(eval $(call gfx_stamp_args,excali64,TARGET=excali64 FLAVOUR="gencon narrow"))
TOCREATE += $(call check_target,excali64,excali64_clib.lib $(CPMLIBS) excali64_cpm.lib)

$(EXCALI64_MC6845_OBJECTS): classic/video/mc6845/obj/excali64/%.o: classic/video/mc6845/%.asm
	$(Q)mkdir -p $(@D)
	$(Q)$(ASSEMBLER) -DFORexcali64 -Iclassic/video/mc6845 -o=$@ $<


excali64_clib.lib: $(TARGET_CLIB_DEPS) $(EXCALI64_MC6845_OBJECTS) classic/games/obj/.stamp-excali64 classic/gfx/obj/.stamp-excali64
	TARGET=excali64 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORexcali64 -x$(OUTPUT_DIRECTORY)/excali64_clib @$(TARGET_DIRECTORY)/excali64/excali64.lst
	@touch $@

excali64_cpm.lib: excali64_clib.lib $(TARGET_CLIB_DEPS) $(EXCALI64_MC6845_OBJECTS) classic/games/obj/.stamp-excali64 classic/gfx/obj/.stamp-excali64
	TARGET=excali64 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORexcali64 -x$(OUTPUT_DIRECTORY)/excali64_cpm @$(TARGET_DIRECTORY)/excali64/excali64_cpm.lst
	@touch $@
