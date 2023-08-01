FONT8x10_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/font/font_8x10/*.asm"
FONT8x10_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/font/font_8x10/*.asm

FONT8x10_NEWLIB_TARGETS := font/font_8x10/obj/newlib-z80-font_8x10 \
	font/font_8x10/obj/newlib-r2k-font_8x10 \
	font/font_8x10/obj/newlib-z80n-font_8x10 \
	font/font_8x10/obj/newlib-ixiy-font_8x10 \
	font/font_8x10/obj/newlib-8080-font_8x10 \
	font/font_8x10/obj/newlib-gbz80-font_8x10 \
	font/font_8x10/obj/newlib-ez80_z80-font_8x10

OBJS += $(FONT8x10_NEWLIB_TARGETS)
CLEAN += font_8x10-clean

font_8x10: $(FONT8x10_NEWLIB_TARGETS)

.PHONY: font_8x10 font_8x10-clean

font/font_8x10/obj/newlib-z80-font_8x10: $(FONT8x10_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x10/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x10/obj/z80/x -I.. -mz80 -D__CLASSIC $(FONT8x10_NEWLIBGLOBS)

font/font_8x10/obj/newlib-r2k-font_8x10: $(FONT8x10_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x10/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x10/obj/r2k/x -I.. -mr2ka -D__CLASSIC $(FONT8x10_NEWLIBGLOBS)

font/font_8x10/obj/newlib-z80n-font_8x10: $(FONT8x10_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x10/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x10/obj/z80n/x -I.. -mz80n -D__CLASSIC $(FONT8x10_NEWLIBGLOBS)

font/font_8x10/obj/newlib-ixiy-font_8x10: $(FONT8x10_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x10/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x10/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(FONT8x10_NEWLIBGLOBS)

font/font_8x10/obj/newlib-8080-font_8x10: $(FONT8x10_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x10/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x10/obj/8080/x -I.. -m8080 -D__CLASSIC $(FONT8x10_NEWLIBGLOBS)

font/font_8x10/obj/newlib-gbz80-font_8x10: $(FONT8x10_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x10/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x10/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(FONT8x10_NEWLIBGLOBS)

font/font_8x10/obj/newlib-ez80_z80-font_8x10: $(FONT8x10_NEWLIBGLOBS_ex)
	@mkdir -p font/font_8x10/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/font_8x10/obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(FONT8x10_NEWLIBGLOBS)

font_8x10-clean:
	$(RM) -fr font/font_8x10/obj
