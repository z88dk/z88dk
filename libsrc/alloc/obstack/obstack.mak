
OBSTACK_CFILES = $(notdir $(wildcard alloc/obstack/*.c))
OBSTACK_AFILES = $(notdir $(wildcard alloc/obstack/*.asm))

OBSTACK_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/alloc/obstack/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/alloc/obstack/z80/*.asm"
OBSTACK_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/alloc/obstack/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/alloc/obstack/z80/*.asm


OBSTACK_NEWLIB_TARGETS := alloc/obstack/obj/newlib-z80-alloc-obstack alloc/obstack/obj/newlib-z80n-alloc-obstack alloc/obstack/obj/newlib-r2k-alloc-obstack alloc/obstack/obj/newlib-ixiy-alloc-obstack  alloc/obstack/obj/newlib-8080-alloc-obstack alloc/obstack/obj/newlib-ez80_z80-alloc-obstack alloc/obstack/obj/newlib-z180-alloc-obstack

OBSTACK_OBJECTS = $(OBSTACK_CFILES:.c=.o) $(OBSTACK_AFILES:.asm=.o)

OBSTACK_OBJS = $(addprefix alloc/obstack/obj/z80/, $(OBSTACK_OBJECTS)) $(addprefix alloc/obstack/obj/r2k/,$(OBSTACK_OBJECTS)) $(addprefix alloc/obstack/obj/ixiy/,$(OBSTACK_OBJECTS))  $(addprefix alloc/obstack/obj/z80n/,$(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/8080/,$(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/z180/,$(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/ez80_z80/,$(OBSTACK_OBJECTS))


OBJS += $(OBSTACK_OBJS) $(OBSTACK_NEWLIB_TARGETS)
CLEAN += alloc-obstack-clean

alloc-obstack: $(OBSTACK_OBJS) $(OBSTACK_NEWLIB_TARGETS)

.PHONY: alloc-obstack alloc-obstack-clean

$(eval $(call buildbit,alloc/obstack,z80,test))
$(eval $(call buildbit,alloc/obstack,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,alloc/obstack,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,alloc/obstack,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,alloc/obstack,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,alloc/obstack,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,alloc/obstack,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,alloc/obstack,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


alloc/obstack/obj/newlib-z80-alloc-obstack: $(OBSTACK_NEWLIBGLOBS_ex)
	@mkdir -p alloc/obstack/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/obstack/obj/z80/x -I.. -mz80 -D__CLASSIC $(OBSTACK_NEWLIBGLOBS)

alloc/obstack/obj/newlib-r2k-alloc-obstack: $(OBSTACK_NEWLIBGLOBS_ex)
	@mkdir -p alloc/obstack/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/obstack/obj/r2k/x -I.. -mr2ka -D__CLASSIC $(OBSTACK_NEWLIBGLOBS)

alloc/obstack/obj/newlib-z80n-alloc-obstack: $(OBSTACK_NEWLIBGLOBS_ex)
	@mkdir -p alloc/obstack/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/obstack/obj/z80n/x -I.. -mz80n -D__CLASSIC $(OBSTACK_NEWLIBGLOBS)

alloc/obstack/obj/newlib-ixiy-alloc-obstack: $(OBSTACK_NEWLIBGLOBS_ex)
	@mkdir -p alloc/obstack/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/obstack/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(OBSTACK_NEWLIBGLOBS)

alloc/obstack/obj/newlib-8080-alloc-obstack: $(OBSTACK_NEWLIBGLOBS_ex)
	@mkdir -p alloc/obstack/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/obstack/obj/8080/x -I.. -m8080 -D__CLASSIC $(OBSTACK_NEWLIBGLOBS)

alloc/obstack/obj/newlib-gbz80-alloc-obstack: $(OBSTACK_NEWLIBGLOBS_ex)
	@mkdir -p alloc/obstack/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/obstack/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(OBSTACK_NEWLIBGLOBS)

alloc/obstack/obj/newlib-ez80_z80-alloc-obstack: $(OBSTACK_NEWLIBGLOBS_ex)
	@mkdir -p alloc/obstack/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/obstack/obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(OBSTACK_NEWLIBGLOBS)

alloc/obstack/obj/newlib-z180-alloc-obstack: $(OBSTACK_NEWLIBGLOBS_ex)
	@mkdir -p alloc/obstack/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/obstack/obj/z180/x -I.. -mz180  -D__CLASSIC $(OBSTACK_NEWLIBGLOBS)

alloc/obstack/obj/%:
	@mkdir -p $@

alloc-obstack-clean:
	$(RM) -fr alloc/obstack/obj alloc/obstack/*.o
	
