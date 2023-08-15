APLIB_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/aplib//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/aplib//z80/*.asm"
APLIB_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/compress/aplib//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/aplib//z80/*.asm

APLIB_8080_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/aplib//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/aplib//8080/*.asm"
APLIB_8080_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/compress/aplib//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/aplib//8080/*.asm

APLIB_NEWLIB_TARGETS := compress/aplib/obj/newlib-z80-compress-aplib compress/aplib/obj/newlib-z80n-compress-aplib \
		compress/aplib/obj/newlib-ixiy-compress-aplib compress/aplib/obj/newlib-8080-compress-aplib \
		compress/aplib/obj/newlib-gbz80-compress-aplib compress/aplib/obj/newlib-ez80_z80-compress-aplib \
	compress/aplib/obj/newlib-z180-compress-aplib

OBJS += $(APLIB_NEWLIB_TARGETS)
CLEAN += compress-aplib-clean

compress-aplib: $(APLIB_NEWLIB_TARGETS)

.PHONY: compress-aplib compress-aplib-clean

compress/aplib/obj/newlib-z80-compress-aplib: $(APLIB_NEWLIBGLOBS_ex)
	@mkdir -p compress/aplib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/aplib/obj/z80/x -I.. -Icompress/aplib -mz80 -D__CLASSIC $(APLIB_NEWLIBGLOBS)

compress/aplib/obj/newlib-r2ka-compress-aplib: $(APLIB_NEWLIBGLOBS_ex)
	@mkdir -p compress/aplib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/aplib/obj/r2ka/x -I.. -Icompress/aplib -mr2ka -D__CLASSIC $(APLIB_NEWLIBGLOBS)

compress/aplib/obj/newlib-z80n-compress-aplib: $(APLIB_NEWLIBGLOBS_ex)
	@mkdir -p compress/aplib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/aplib/obj/z80n/x -I.. -Icompress/aplib -mz80n -D__CLASSIC $(APLIB_NEWLIBGLOBS)

compress/aplib/obj/newlib-ixiy-compress-aplib: $(APLIB_NEWLIBGLOBS_ex)
	@mkdir -p compress/aplib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/aplib/obj/ixiy/x -I.. -Icompress/aplib -mz80 -IXIY -D__CLASSIC $(APLIB_NEWLIBGLOBS)

compress/aplib/obj/newlib-8080-compress-aplib: $(APLIB_8080_NEWLIBGLOBS_ex)
	@mkdir -p compress/aplib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/aplib/obj/8080/x -I.. -Icompress/aplib -m8080 -D__CLASSIC $(APLIB_8080_NEWLIBGLOBS)

compress/aplib/obj/newlib-gbz80-compress-aplib: $(APLIB_8080_NEWLIBGLOBS_ex)
	@mkdir -p compress/aplib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/aplib/obj/gbz80/x -I.. -Icompress/aplib -mgbz80 -D__CLASSIC $(APLIB_8080_NEWLIBGLOBS)

compress/aplib/obj/newlib-z180-compress-aplib: $(APLIB_NEWLIBGLOBS_ex)
	@mkdir -p compress/aplib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/aplib/obj/z180/x -I.. -Icompress/aplib -mz180 -D__CLASSIC $(APLIB_NEWLIBGLOBS)

compress/aplib/obj/newlib-ez80_z80-compress-aplib: $(APLIB_NEWLIBGLOBS_ex)
	@mkdir -p compress/aplib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/aplib/obj/ez80_z80/x -I.. -Icompress/aplib -mez80_z80 -D__CLASSIC $(APLIB_NEWLIBGLOBS)

compress-aplib-clean:
	$(RM) -fr compress/aplib/obj 
