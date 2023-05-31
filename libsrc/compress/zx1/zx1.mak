ZX1_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/zx1//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx1//z80/*.asm"
ZX1_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/compress/zx1//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/zx1//z80/*.asm

ZX1_8080_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/zx1//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx1//8080/*.asm"
ZX1_8080_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/compress/zx1//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/zx1//8080/*.asm

ZX1_NEWLIB_TARGETS := compress/zx1/obj/newlib-z80-compress-zx1 compress/zx1/obj/newlib-z80n-compress-zx1 \
		compress/zx1/obj/newlib-ixiy-compress-zx1 compress/zx1/obj/newlib-8080-compress-zx1 \
		compress/zx1/obj/newlib-r2k-compress-zx1 

OBJS += $(ZX1_NEWLIB_TARGETS)
CLEAN += compress-zx1-clean

compress-zx1: $(ZX1_NEWLIB_TARGETS)

.PHONY: compress-zx1 compress-zx1-clean

compress/zx1/obj/newlib-z80-compress-zx1: $(ZX1_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx1/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx1/obj/z80/x -I.. -mz80 -D__CLASSIC $(ZX1_NEWLIBGLOBS)

compress/zx1/obj/newlib-r2k-compress-zx1: $(ZX1_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx1/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx1/obj/r2k/x -I.. -mr2ka -D__CLASSIC $(ZX1_NEWLIBGLOBS)

compress/zx1/obj/newlib-z80n-compress-zx1: $(ZX1_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx1/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx1/obj/z80n/x -I.. -mz80n -D__CLASSIC $(ZX1_NEWLIBGLOBS)

compress/zx1/obj/newlib-ixiy-compress-zx1: $(ZX1_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx1/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx1/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(ZX1_NEWLIBGLOBS)

compress/zx1/obj/newlib-8080-compress-zx1: $(ZX1_8080_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx1/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx1/obj/8080/x -I.. -m8080 -D__CLASSIC $(ZX1_8080_NEWLIBGLOBS)

compress/zx1/obj/newlib-gbz80-compress-zx1: $(ZX1_NEWLIBGLOBS_ex)
	@mkdir -p compress/zx1/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=compress/zx1/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(ZX1_NEWLIBGLOBS)


compress-zx1-clean:
	$(RM) -fr compress/zx1/obj
