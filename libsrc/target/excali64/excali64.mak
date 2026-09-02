EXCALI64_MC6845_SOURCES := $(wildcard classic/video/mc6845/*.asm)
EXCALI64_MC6845_OBJECTS := $(patsubst classic/video/mc6845/%.asm,classic/video/mc6845/obj/excali64/%.o,$(EXCALI64_MC6845_SOURCES))

$(EXCALI64_MC6845_OBJECTS): classic/video/mc6845/obj/excali64/%.o: classic/video/mc6845/%.asm
	$(Q)mkdir -p $(@D)
	$(Q)$(ASSEMBLER) -DFORexcali64 -Iclassic/video/mc6845 -o=$@ $<

$(eval $(call gfx_stamp_args,excali64,TARGET=excali64 FLAVOUR="gencon narrow"))
