ZX0_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/zx0//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx0//z80/*.asm"
ZX0_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/compress/zx0//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/zx0//z80/*.asm

ZX0_8080_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/zx0//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx0//8080/*.asm"
ZX0_8080_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/compress/zx0//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/zx0//8080/*.asm

ZX0_NEWLIB_TARGETS := compress/zx0/obj/newlib-z80-compress-zx0 compress/zx0/obj/newlib-z80n-compress-zx0 \
		compress/zx0/obj/newlib-ixiy-compress-zx0 compress/zx0/obj/newlib-8080-compress-zx0 \
		compress/zx0/obj/newlib-r2ka-compress-zx0 compress/zx0/obj/newlib-ez80_z80-compress-zx0 \
		compress/zx0/obj/newlib-z180-compress-zx0 compress/zx0/obj/newlib-r4k-compress-zx0

OBJS += $(ZX0_NEWLIB_TARGETS)
CLEAN += compress-zx0-clean

compress-zx0: $(ZX0_NEWLIB_TARGETS)

.PHONY: compress-zx0 compress-zx0-clean

compress/zx0/obj/newlib-z80-compress-zx0: $(ZX0_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx0/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx0/obj/z80/x -I.. -mz80 -D__CLASSIC $(ZX0_NEWLIBGLOBS)

compress/zx0/obj/newlib-r2ka-compress-zx0: $(ZX0_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx0/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx0/obj/r2ka/x -I.. -mr2ka -D__CLASSIC $(ZX0_NEWLIBGLOBS)
compress/zx0/obj/newlib-r4k-compress-zx0: $(ZX0_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx0/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx0/obj/r4k/x -I.. -mr4k -D__CLASSIC $(ZX0_NEWLIBGLOBS)

compress/zx0/obj/newlib-z80n-compress-zx0: $(ZX0_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx0/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx0/obj/z80n/x -I.. -mz80n -D__CLASSIC $(ZX0_NEWLIBGLOBS)

compress/zx0/obj/newlib-ixiy-compress-zx0: $(ZX0_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx0/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx0/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(ZX0_NEWLIBGLOBS)

compress/zx0/obj/newlib-8080-compress-zx0: $(ZX0_8080_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx0/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx0/obj/8080/x -I.. -m8080 -D__CLASSIC $(ZX0_8080_NEWLIBGLOBS)

compress/zx0/obj/newlib-gbz80-compress-zx0: $(ZX0_8080_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx0/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx0/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(ZX0_8080_NEWLIBGLOBS)

compress/zx0/obj/newlib-z180-compress-zx0: $(ZX0_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx0/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx0/obj/z180/x -I.. -mz180 -D__CLASSIC $(ZX0_NEWLIBGLOBS)

compress/zx0/obj/newlib-ez80_z80-compress-zx0: $(ZX0_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx0/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx0/obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(ZX0_NEWLIBGLOBS)

compress-zx0-clean:
	$(RM) -fr compress/zx0/obj
