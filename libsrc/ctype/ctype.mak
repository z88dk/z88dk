CTYPE_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/ctype/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/ctype/z80/*.asm"
CTYPE_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/ctype/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/ctype/z80/*.asm

CTYPE_NEWLIB_TARGETS := ctype/obj/newlib-z80-ctype ctype/obj/newlib-z80n-ctype ctype/obj/newlib-r2ka-ctype \
		 ctype/obj/newlib-ixiy-ctype ctype/obj/newlib-8080-ctype ctype/obj/newlib-gbz80-ctype \
		ctype/obj/newlib-z180-ctype \
		ctype/obj/newlib-r4k-ctype \
		ctype/obj/newlib-ez80_z80-ctype 
		

OBJS += $(CTYPE_NEWLIB_TARGETS)
CLEAN += ctype-clean

ctype: $(CTYPE_NEWLIB_TARGETS)

.PHONY: ctype ctype-clean

ctype/obj/newlib-z80-ctype: $(CTYPE_NEWLIBGLOBS_ex)
	@mkdir -p ctype/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=ctype/obj/z80/x -I.. -mz80 -D__CLASSIC $(CTYPE_NEWLIBGLOBS)

ctype/obj/newlib-r2ka-ctype: $(CTYPE_NEWLIBGLOBS_ex)
	@mkdir -p ctype/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=ctype/obj/r2ka/x -I.. -mr2ka -D__CLASSIC $(CTYPE_NEWLIBGLOBS)

ctype/obj/newlib-r4k-ctype: $(CTYPE_NEWLIBGLOBS_ex)
	@mkdir -p ctype/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=ctype/obj/r4k/x -I.. -mr4k -D__CLASSIC $(CTYPE_NEWLIBGLOBS)

ctype/obj/newlib-z80n-ctype: $(CTYPE_NEWLIBGLOBS_ex)
	@mkdir -p ctype/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=ctype/obj/z80n/x -I.. -mz80n -D__CLASSIC $(CTYPE_NEWLIBGLOBS)

ctype/obj/newlib-ixiy-ctype: $(CTYPE_NEWLIBGLOBS_ex)
	@mkdir -p ctype/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=ctype/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(CTYPE_NEWLIBGLOBS)

ctype/obj/newlib-8080-ctype: $(CTYPE_NEWLIBGLOBS_ex)
	@mkdir -p ctype/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=ctype/obj/8080/x -I.. -m8080 -D__CLASSIC $(CTYPE_NEWLIBGLOBS)

ctype/obj/newlib-gbz80-ctype: $(CTYPE_NEWLIBGLOBS_ex)
	@mkdir -p ctype/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=ctype/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(CTYPE_NEWLIBGLOBS)

ctype/obj/newlib-z180-ctype: $(CTYPE_NEWLIBGLOBS_ex)
	@mkdir -p ctype/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=ctype/obj/z180/x -I.. -mz180 -D__CLASSIC $(CTYPE_NEWLIBGLOBS)

ctype/obj/newlib-ez80_z80-ctype: $(CTYPE_NEWLIBGLOBS_ex)
	@mkdir -p ctype/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=ctype/obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(CTYPE_NEWLIBGLOBS)


ctype-clean:
	$(RM) -fr ctype/obj
