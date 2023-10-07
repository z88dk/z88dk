LIBGEN_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/libgen/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/libgen/z80/*.asm"
LIBGEN_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/libgen/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/libgen/z80/*.asm

LIBGEN_NEWLIB_TARGETS := libgen/obj/newlib-z80-libgen libgen/obj/newlib-z80n-libgen libgen/obj/newlib-r2ka-libgen \
		 libgen/obj/newlib-ixiy-libgen libgen/obj/newlib-8080-libgen libgen/obj/newlib-gbz80-libgen \
		libgen/obj/newlib-r4k-libgen \
		libgen/obj/newlib-z180-libgen \
		libgen/obj/newlib-kc160-libgen \
		libgen/obj/newlib-ez80_z80-libgen

OBJS += $(LIBGEN_NEWLIB_TARGETS)
CLEAN += libgen-clean

libgen: $(LIBGEN_NEWLIB_TARGETS)

.PHONY: libgen libgen-clean

libgen/obj/newlib-z80-libgen: $(LIBGEN_NEWLIBGLOBS_ex)
	@mkdir -p libgen/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=libgen/obj/z80/x -I.. -mz80 -D__CLASSIC $(LIBGEN_NEWLIBGLOBS)

libgen/obj/newlib-r2ka-libgen: $(LIBGEN_NEWLIBGLOBS_ex)
	@mkdir -p libgen/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=libgen/obj/r2ka/x -I.. -mr2ka -D__CLASSIC $(LIBGEN_NEWLIBGLOBS)

libgen/obj/newlib-r4k-libgen: $(LIBGEN_NEWLIBGLOBS_ex)
	@mkdir -p libgen/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=libgen/obj/r4k/x -I.. -mr4k -D__CLASSIC $(LIBGEN_NEWLIBGLOBS)

libgen/obj/newlib-z80n-libgen: $(LIBGEN_NEWLIBGLOBS_ex)
	@mkdir -p libgen/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=libgen/obj/z80n/x -I.. -mz80n -D__CLASSIC $(LIBGEN_NEWLIBGLOBS)

libgen/obj/newlib-ixiy-libgen: $(LIBGEN_NEWLIBGLOBS_ex)
	@mkdir -p libgen/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=libgen/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(LIBGEN_NEWLIBGLOBS)

libgen/obj/newlib-8080-libgen: $(LIBGEN_NEWLIBGLOBS_ex)
	@mkdir -p libgen/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=libgen/obj/8080/x -I.. -m8080 -D__CLASSIC $(LIBGEN_NEWLIBGLOBS)

libgen/obj/newlib-gbz80-libgen: $(LIBGEN_NEWLIBGLOBS_ex)
	@mkdir -p libgen/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=libgen/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(LIBGEN_NEWLIBGLOBS)

libgen/obj/newlib-z180-libgen: $(LIBGEN_NEWLIBGLOBS_ex)
	@mkdir -p libgen/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=libgen/obj/z180/x -I.. -mz180 -D__CLASSIC $(LIBGEN_NEWLIBGLOBS)

libgen/obj/newlib-ez80_z80-libgen: $(LIBGEN_NEWLIBGLOBS_ex)
	@mkdir -p libgen/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=libgen/obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(LIBGEN_NEWLIBGLOBS)

libgen/obj/newlib-kc160-libgen: $(LIBGEN_NEWLIBGLOBS_ex)
	@mkdir -p libgen/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=libgen/obj/kc160/x -I.. -mkc160 -D__CLASSIC $(LIBGEN_NEWLIBGLOBS)

libgen-clean:
	$(RM) -fr libgen/obj
