ALPHATRO_MC6845_SOURCES := $(wildcard classic/video/mc6845/*.asm)
ALPHATRO_MC6845_OBJECTS := $(patsubst classic/video/mc6845/%.asm,classic/video/mc6845/obj/alphatro/%.o,$(ALPHATRO_MC6845_SOURCES))

$(ALPHATRO_MC6845_OBJECTS): classic/video/mc6845/obj/alphatro/%.o: classic/video/mc6845/%.asm
	$(Q)mkdir -p $(@D)
	$(Q)$(ASSEMBLER) -DFORalphatro -Iclassic/video/mc6845 -o=$@ $<

$(eval $(call gfx_stamp_args,alphatro,TARGET=alphatro FLAVOUR="gencon narrow"))
