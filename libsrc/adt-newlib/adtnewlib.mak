ADT_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/adt/*/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/adt/*/z80/*.asm"
ADT_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/adt/*/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/adt/*/z80/*.asm

ADT_NEWLIB_TARGETS := adt-newlib/obj/newlib-z80-adt-newlib \
	adt-newlib/obj/newlib-z80n-adt-newlib \
	adt-newlib/obj/newlib-r2ka-adt-newlib \
	adt-newlib/obj/newlib-r4k-adt-newlib \
	adt-newlib/obj/newlib-ixiy-adt-newlib \
	adt-newlib/obj/newlib-z180-adt-newlib \
	adt-newlib/obj/newlib-ez80_z80-adt-newlib 

OBJS += $(ADT_NEWLIB_TARGETS)
CLEAN += adt-newlib-clean

adt-newlib: $(ADT_NEWLIB_TARGETS)

.PHONY: adt-newlib adt-newlib-clean

adt-newlib/obj/newlib-z80-adt-newlib: $(ADT_NEWLIBGLOBS_ex)
	@mkdir -p adt-newlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=adt-newlib/obj/z80/x -I.. -mz80 -D__CLASSIC $(ADT_NEWLIBGLOBS)

adt-newlib/obj/newlib-r2ka-adt-newlib: $(ADT_NEWLIBGLOBS_ex)
	@mkdir -p adt-newlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=adt-newlib/obj/r2ka/x -I.. -mr2ka -D__CLASSIC $(ADT_NEWLIBGLOBS)

adt-newlib/obj/newlib-r4k-adt-newlib: $(ADT_NEWLIBGLOBS_ex)
	@mkdir -p adt-newlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=adt-newlib/obj/r4k/x -I.. -mr4k -D__CLASSIC $(ADT_NEWLIBGLOBS)

adt-newlib/obj/newlib-z80n-adt-newlib: $(ADT_NEWLIBGLOBS_ex)
	@mkdir -p adt-newlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=adt-newlib/obj/z80n/x -I.. -mz80n -D__CLASSIC $(ADT_NEWLIBGLOBS)

adt-newlib/obj/newlib-ixiy-adt-newlib: $(ADT_NEWLIBGLOBS_ex)
	@mkdir -p adt-newlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=adt-newlib/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(ADT_NEWLIBGLOBS)

adt-newlib/obj/newlib-8080-adt-newlib: $(ADT_NEWLIBGLOBS_ex)
	@mkdir -p adt-newlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=adt-newlib/obj/8080/x -I.. -m8080 -D__CLASSIC $(ADT_NEWLIBGLOBS)

adt-newlib/obj/newlib-gbz80-adt-newlib: $(ADT_NEWLIBGLOBS_ex)
	@mkdir -p adt-newlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=adt-newlib/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(ADT_NEWLIBGLOBS)

adt-newlib/obj/newlib-z180-adt-newlib: $(ADT_NEWLIBGLOBS_ex)
	@mkdir -p adt-newlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=adt-newlib/obj/z180/x -I.. -mz180 -D__CLASSIC $(ADT_NEWLIBGLOBS)

adt-newlib/obj/newlib-ez80_z80-adt-newlib: $(ADT_NEWLIBGLOBS_ex)
	@mkdir -p adt-newlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=adt-newlib/obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(ADT_NEWLIBGLOBS)


adt-newlib-clean:
	$(RM) -fr adt-newlib/obj
