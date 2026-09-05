ALPHATRO_SOURCES := $(call rwildcard,target/alphatro,*.asm)
ALPHATRO_MC6845_SOURCES := $(wildcard classic/video/mc6845/*.asm)
ALPHATRO_MC6845_OBJECTS := $(patsubst classic/video/mc6845/%.asm,classic/video/mc6845/obj/alphatro/%.o,$(ALPHATRO_MC6845_SOURCES))
ALPHATRO_TARGETS := target/alphatro/obj/target-alphatro-alphatro \
	$(ALPHATRO_MC6845_OBJECTS) \
	classic/games/obj/.stamp-alphatro \
	classic/gfx/obj/.stamp-alphatro

$(eval $(call gfx_stamp_args,alphatro,TARGET=alphatro FLAVOUR="gencon narrow"))
CLEAN += target-alphatro-clean
TOCREATE += $(call check_target,alphatro,alphatro_clib.lib alphatro_cpm.lib)
$(eval $(call buildtargetasm,target/alphatro,z80,alphatro,-mz80,$(ALPHATRO_SOURCES),$(ALPHATRO_SOURCES)))

$(ALPHATRO_MC6845_OBJECTS): classic/video/mc6845/obj/alphatro/%.o: classic/video/mc6845/%.asm
	$(Q)mkdir -p $(@D)
	$(Q)$(ASSEMBLER) -DFORalphatro -Iclassic/video/mc6845 -o=$@ $<

alphatro_clib.lib: $(TARGET_CLIB_DEPS) $(ALPHATRO_TARGETS)
	TARGET=alphatro TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORalphatro -x$(OUTPUT_DIRECTORY)/alphatro_clib @$(TARGET_DIRECTORY)/alphatro/alphatro.lst
	@touch $@

alphatro_cpm.lib: alphatro_clib.lib $(TARGET_CLIB_DEPS) $(ALPHATRO_TARGETS)
	TARGET=alphatro TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORalphatro -x$(OUTPUT_DIRECTORY)/alphatro_cpm @$(TARGET_DIRECTORY)/alphatro/alphatro_cpm.lst
	@touch $@

target-alphatro: $(ALPHATRO_TARGETS)

.PHONY: target-alphatro target-alphatro-clean

target-alphatro-clean:
	$(RM) -fr target/alphatro/obj
