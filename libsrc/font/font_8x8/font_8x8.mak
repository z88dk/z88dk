FONT8x8_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/font/font_8x8/*.asm"
FONT8x8_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/font/font_8x8/*.asm

FONT8x8_NEWLIB_TARGETS := font/font_8x8/obj/newlib-z80-font_8x8

OBJS += $(FONT8x8_NEWLIB_TARGETS)
CLEAN += font_8x8-clean

font_8x8: $(FONT8x8_NEWLIB_TARGETS)

.PHONY: font_8x8 font_8x8-clean

font/font_8x8/obj/newlib-z80-font_8x8: $(FONT8x8_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x8/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x8/obj/z80/x -I.. -mz80 -D__CLASSIC $(FONT8x8_NEWLIBGLOBS)

font/font_8x8/obj/newlib-r2k-font_8x8: $(FONT8x8_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x8/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x8/obj/r2k/x -I.. -mr2ka -D__CLASSIC $(FONT8x8_NEWLIBGLOBS)

font/font_8x8/obj/newlib-z80n-font_8x8: $(FONT8x8_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x8/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x8/obj/z80n/x -I.. -mz80n -D__CLASSIC $(FONT8x8_NEWLIBGLOBS)

font/font_8x8/obj/newlib-ixiy-font_8x8: $(FONT8x8_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x8/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x8/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(FONT8x8_NEWLIBGLOBS)

font/font_8x8/obj/newlib-8080-font_8x8: $(FONT8x8_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x8/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x8/obj/8080/x -I.. -m8080 -D__CLASSIC $(FONT8x8_NEWLIBGLOBS)

font/font_8x8/obj/newlib-gbz80-font_8x8: $(FONT8x8_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x8/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x8/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(FONT8x8_NEWLIBGLOBS)


font_8x8-clean:
	$(RM) -fr font/font_8x8/obj
