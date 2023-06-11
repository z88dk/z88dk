ZX2_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/zx2//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx2//z80/*.asm"
ZX2_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/compress/zx2//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/zx2//z80/*.asm


ZX2_NEWLIB_TARGETS := compress/zx2/obj/newlib-z80-compress-zx2 compress/zx2/obj/newlib-z80n-compress-zx2 \
		compress/zx2/obj/newlib-ixiy-compress-zx2 compress/zx2/obj/newlib-r2k-compress-zx2 \
		compress/zx2/obj/newlib-gbz80-compress-zx2 compress/zx2/obj/newlib-ez80_z80-compress-zx2

OBJS += $(ZX2_NEWLIB_TARGETS)
CLEAN += compress-zx2-clean

compress-zx2: $(ZX2_NEWLIB_TARGETS)

.PHONY: compress-zx2 compress-zx2-clean

compress/zx2/obj/newlib-z80-compress-zx2: $(ZX2_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx2/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx2/obj/z80/x -I.. -mz80 -D__CLASSIC $(ZX2_NEWLIBGLOBS)

compress/zx2/obj/newlib-r2k-compress-zx2: $(ZX2_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx2/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx2/obj/r2k/x -I.. -mr2ka -D__CLASSIC $(ZX2_NEWLIBGLOBS)

compress/zx2/obj/newlib-z80n-compress-zx2: $(ZX2_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx2/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx2/obj/z80n/x -I.. -mz80n -D__CLASSIC $(ZX2_NEWLIBGLOBS)

compress/zx2/obj/newlib-ixiy-compress-zx2: $(ZX2_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx2/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx2/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(ZX2_NEWLIBGLOBS)

compress/zx2/obj/newlib-8080-compress-zx2: $(ZX2_8080_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx2/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx2/obj/8080/x -I.. -m8080 -D__CLASSIC $(ZX2_8080_NEWLIBGLOBS)

compress/zx2/obj/newlib-gbz80-compress-zx2: $(ZX2_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx2/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx2/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(ZX2_NEWLIBGLOBS)

compress/zx2/obj/newlib-ez80_z80-compress-zx2: $(ZX2_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx2/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx2/obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(ZX2_NEWLIBGLOBS)

compress-zx2-clean:
	$(RM) -fr compress/zx2/obj
