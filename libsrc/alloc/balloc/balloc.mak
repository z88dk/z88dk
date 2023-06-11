
BALLOC_CFILES = $(notdir $(wildcard alloc/balloc/*.c))
BALLOC_AFILES = $(notdir $(wildcard alloc/balloc/*.asm))

BALLOC_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/alloc/balloc/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/alloc/balloc/z80/*.asm"
BALLOC_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/alloc/balloc/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/alloc/balloc/z80/*.asm

BALLOC_NEWLIB_TARGETS := alloc/balloc/obj/newlib-z80-alloc-balloc alloc/balloc/obj/newlib-z80n-alloc-balloc alloc/balloc/obj/newlib-r2k-alloc-balloc alloc/balloc/obj/newlib-ixiy-alloc-balloc 

BALLOC_OBJECTS = $(BALLOC_CFILES:.c=.o) $(BALLOC_AFILES:.asm=.o)

BALLOC_OBJS = $(addprefix alloc/balloc/obj/z80/, $(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/r2k/,$(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/ixiy/,$(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/z80n/,$(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/ez80_z80/,$(BALLOC_OBJECTS))


OBJS += $(BALLOC_OBJS) $(BALLOC_NEWLIB_TARGETS)
CLEAN += alloc-balloc-clean

alloc-balloc: $(BALLOC_OBJS) $(BALLOC_NEWLIB_TARGETS)

.PHONY: alloc-balloc alloc-balloc-clean

$(eval $(call buildbit,alloc/balloc,z80,test))
$(eval $(call buildbit,alloc/balloc,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,alloc/balloc,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,alloc/balloc,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,alloc/balloc,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,alloc/balloc,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,alloc/balloc,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


alloc/balloc/obj/newlib-z80-alloc-balloc: $(BALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/balloc/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/balloc/obj/z80/x -I.. -mz80 -D__CLASSIC $(BALLOC_NEWLIBGLOBS)

alloc/balloc/obj/newlib-r2k-alloc-balloc: $(BALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/balloc/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/balloc/obj/r2k/x -I.. -mr2ka -D__CLASSIC $(BALLOC_NEWLIBGLOBS)

alloc/balloc/obj/newlib-z80n-alloc-balloc: $(BALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/balloc/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/balloc/obj/z80n/x -I.. -mz80n -D__CLASSIC $(BALLOC_NEWLIBGLOBS)

alloc/balloc/obj/newlib-ixiy-alloc-balloc: $(BALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/balloc/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/balloc/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(BALLOC_NEWLIBGLOBS)

alloc/balloc/obj/newlib-8080-alloc-balloc: $(BALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/balloc/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/balloc/obj/8080/x -I.. -m8080 -D__CLASSIC $(BALLOC_NEWLIBGLOBS)

alloc/balloc/obj/newlib-gbz80-alloc-balloc: $(BALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/balloc/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/balloc/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(BALLOC_NEWLIBGLOBS)

alloc/balloc/obj/%:
	@mkdir -p $@

alloc-balloc-clean:
	$(RM) -fr alloc/balloc/obj alloc/balloc/*.o
	
