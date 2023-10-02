ARCHZ80_AFILES = $(notdir $(wildcard arch/z80/*.asm))
ARCHZ80_CFILES = $(notdir $(wildcard arch/z80/*.c))

ARCHZ80_R2KA_AFILES = 
ARCHZ80_R2KA_CFILES = $(notdir $(wildcard arch/z80/*.c))


ARCHZ80_OBJECTS = $(ARCHZ80_CFILES:.c=.o) $(ARCHZ80_AFILES:.asm=.o)
ARCHZ80_R2KA_OBJECTS = $(ARCHZ80_R2KA_CFILES:.c=.o) $(ARCHZ80_R2KA_AFILES:.asm=.o)

ARCHZ80_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/z80/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/z80/z80/*.asm"
ARCHZ80_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/z80/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/z80/z80/*.asm


ARCHZ80_NEWLIB_TARGETS := arch/z80/obj/newlib-z80-arch-z80 arch/z80/obj/newlib-z80n-arch-z80 arch/z80/obj/newlib-ixiy-arch-z80  

ARCHZ80_OBJECTS = $(ARCHZ80_CFILES:.c=.o) $(ARCHZ80_AFILES:.asm=.o)

ARCHZ80_OBJS = $(addprefix arch/z80/obj/z80/, $(ARCHZ80_OBJECTS)) $(addprefix arch/z80/obj/ixiy/,$(ARCHZ80_OBJECTS))  $(addprefix arch/z80/obj/z80n/,$(ARCHZ80_OBJECTS))  $(addprefix arch/z80/obj/r2ka/, $(ARCHZ80_R2KA_OBJECTS)) \
	$(addprefix arch/z80/obj/r4k/, $(ARCHZ80_OBJECTS)) \
	$(addprefix arch/z80/obj/z180/, $(ARCHZ80_OBJECTS)) \
	$(addprefix arch/z80/obj/ez80_z80/, $(ARCHZ80_OBJECTS))


OBJS += $(ARCHZ80_OBJS) $(ARCHZ80_NEWLIB_TARGETS)
CLEAN += arch-z80-clean

arch-z80: $(ARCHZ80_OBJS) $(ARCHZ80_NEWLIB_TARGETS)

.PHONY: arch/z80 arch/z80-clean

$(eval $(call buildbit,arch/z80,z80,test))
$(eval $(call buildbit,arch/z80,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,arch/z80,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,arch/z80,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,arch/z80,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,arch/z80,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,arch/z80,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


arch/z80/obj/newlib-z80-arch-z80: $(ARCHZ80_NEWLIBGLOBS_ex)
	@mkdir -p arch/z80/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=arch/z80/obj/z80/x -I.. -mz80 -D__CLASSIC $(ARCHZ80_NEWLIBGLOBS)

arch/z80/obj/newlib-z80n-arch-z80: $(ARCHZ80_NEWLIBGLOBS_ex)
	@mkdir -p arch/z80/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=arch/z80/obj/z80n/x -I.. -mz80n -D__CLASSIC $(ARCHZ80_NEWLIBGLOBS)

arch/z80/obj/newlib-ixiy-arch-z80: $(ARCHZ80_NEWLIBGLOBS_ex)
	@mkdir -p arch/z80/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=arch/z80/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(ARCHZ80_NEWLIBGLOBS)

arch/z80/obj/newlib-ez80_z80-arch-z80: $(ARCHZ80_NEWLIBGLOBS_ex)
	@mkdir -p arch/z80/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=arch/z80/obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(ARCHZ80_NEWLIBGLOBS)


arch-z80-clean:
	$(RM) -fr arch/z80/obj arch/z80/*.o
