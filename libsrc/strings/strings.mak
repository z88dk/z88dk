STRINGS_AFILES = memopd.asm memopd_callee.asm memopi.asm memopi_callee.asm memops.asm $(wildcard _*.asm)
STRINGS_CFILES = 

STRINGS_8080_AFILES = 
STRINGS_GBZ80_AFILES = 

STRINGS_OBJECTS = $(STRINGS_CFILES:.c=.o) $(STRINGS_AFILES:.asm=.o)
STRINGS_8080_OBJECTS = $(STRINGS_CFILES:.c=.o) $(STRINGS_8080_AFILES:.asm=.o)
STRINGS_GBZ80_OBJECTS = $(STRINGS_CFILES:.c=.o) $(STRINGS_GBZ80_AFILES:.asm=.o)

STRINGS_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/string/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/string/z80/*.asm"
STRINGS_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/string/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/string/z80/*.asm

STRINGS_NEWLIB_TARGETS := strings/obj/newlib-z80-strings strings/obj/newlib-z80n-strings strings/obj/newlib-r2ka-strings strings/obj/newlib-ixiy-strings strings/obj/newlib-8080-strings strings/obj/newlib-gbz80-strings strings/obj/newlib-ez80_z80-strings strings/obj/newlib-z180-strings

STRINGS_OBJECTS = $(STRINGS_CFILES:.c=.o) $(STRINGS_AFILES:.asm=.o)

STRINGS_OBJS = $(addprefix strings/obj/z80/, $(STRINGS_OBJECTS)) \
	$(addprefix strings/obj/r2ka/,$(STRINGS_OBJECTS)) \
	$(addprefix strings/obj/ixiy/,$(STRINGS_OBJECTS)) \
	$(addprefix strings/obj/z80n/,$(STRINGS_OBJECTS)) \
	$(addprefix strings/obj/8080/,$(STRINGS_8080_OBJECTS)) \
	$(addprefix strings/obj/gbz80/,$(STRINGS_GBZ80_OBJECTS)) \
	$(addprefix strings/obj/z180/,$(STRINGS_OBJECTS)) \
	$(addprefix strings/obj/ez80_z80/,$(STRINGS_OBJECTS)) 

OBJS += $(STRINGS_OBJS) $(STRINGS_NEWLIB_TARGETS)
CLEAN += strings-clean

strings: $(STRINGS_OBJS) $(STRINGS_NEWLIB_TARGETS)

.PHONY: strings strings-clean

$(eval $(call buildbit,strings,z80,test))
$(eval $(call buildbit,strings,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,strings,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,strings,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,strings,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,strings,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,strings,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,strings,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


strings/obj/newlib-z80-strings: $(STRINGS_NEWLIBGLOBS_ex)
	@mkdir -p strings/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=strings/obj/z80/x -I.. -mz80 -D__CLASSIC $(STRINGS_NEWLIBGLOBS)

strings/obj/newlib-r2ka-strings: $(STRINGS_NEWLIBGLOBS_ex)
	@mkdir -p strings/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=strings/obj/r2ka/x -I.. -mr2ka -D__CLASSIC $(STRINGS_NEWLIBGLOBS)

strings/obj/newlib-z80n-strings: $(STRINGS_NEWLIBGLOBS_ex)
	@mkdir -p strings/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=strings/obj/z80n/x -I.. -mz80n -D__CLASSIC $(STRINGS_NEWLIBGLOBS)

strings/obj/newlib-ixiy-strings: $(STRINGS_NEWLIBGLOBS_ex)
	@mkdir -p strings/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=strings/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(STRINGS_NEWLIBGLOBS)

strings/obj/newlib-8080-strings: $(STRINGS_NEWLIBGLOBS_ex)
	@mkdir -p strings/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=strings/obj/8080/x -I.. -m8080 -D__CLASSIC $(STRINGS_NEWLIBGLOBS)

strings/obj/newlib-gbz80-strings: $(STRINGS_NEWLIBGLOBS_ex)
	@mkdir -p strings/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=strings/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(STRINGS_NEWLIBGLOBS)

strings/obj/newlib-z180-strings: $(STRINGS_NEWLIBGLOBS_ex)
	@mkdir -p strings/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=strings/obj/z180/x -I.. -mz180 -D__CLASSIC $(STRINGS_NEWLIBGLOBS)

strings/obj/newlib-ez80_z80-strings: $(STRINGS_NEWLIBGLOBS_ex)
	@mkdir -p strings/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=strings/obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(STRINGS_NEWLIBGLOBS)


strings-clean:
	$(RM) -fr strings/obj strings/*.o
