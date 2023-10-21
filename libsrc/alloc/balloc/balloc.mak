
BALLOC_CFILES := $(notdir $(wildcard alloc/balloc/*.c))
BALLOC_AFILES := $(notdir $(wildcard alloc/balloc/*.asm))

BALLOC_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/alloc/balloc/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/alloc/balloc/z80/*.asm"
BALLOC_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/alloc/balloc/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/alloc/balloc/z80/*.asm

BALLOC_NEWLIB_TARGETS := alloc/balloc/obj/newlib-z80-alloc-balloc \
		alloc/balloc/obj/newlib-z80n-alloc-balloc \
		alloc/balloc/obj/newlib-r2ka-alloc-balloc \
		alloc/balloc/obj/newlib-ixiy-alloc-balloc \
		alloc/balloc/obj/newlib-z180-alloc-balloc \
		alloc/balloc/obj/newlib-ez80_z80-alloc-balloc \
		alloc/balloc/obj/newlib-r4k-alloc-balloc \
		alloc/balloc/obj/newlib-kc160-alloc-balloc 


BALLOC_OBJECTS := $(BALLOC_CFILES:.c=.o) $(BALLOC_AFILES:.asm=.o)

BALLOC_OBJS := $(addprefix alloc/balloc/obj/z80/, $(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/r2ka/,$(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/r4k/,$(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/ixiy/,$(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/z80n/,$(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/z180/,$(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/ez80_z80/,$(BALLOC_OBJECTS)) \
	$(addprefix alloc/balloc/obj/kc160/,$(BALLOC_OBJECTS)) 


OBJS += $(BALLOC_OBJS) $(BALLOC_NEWLIB_TARGETS)
CLEAN += alloc-balloc-clean

alloc-balloc: $(BALLOC_OBJS) $(BALLOC_NEWLIB_TARGETS)

.PHONY: alloc-balloc alloc-balloc-clean

$(eval $(call buildbit,alloc/balloc,z80,test))
$(eval $(call buildbit,alloc/balloc,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,alloc/balloc,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,alloc/balloc,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,alloc/balloc,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,alloc/balloc,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,alloc/balloc,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,alloc/balloc,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,alloc/balloc,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,alloc/balloc,kc160,test,-clib=kc160,-mkc160))

$(eval $(call buildnew,alloc/balloc,z80,-mz80,$(BALLOC_NEWLIBGLOBS),$(BALLOC_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,r2ka,-mr2ka,$(BALLOC_NEWLIBGLOBS),$(BALLOC_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,r4k,-mr4k,$(BALLOC_NEWLIBGLOBS),$(BALLOC_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,z80n,-mz80n,$(BALLOC_NEWLIBGLOBS),$(BALLOC_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,ixiy,-mz80 -IXIY,$(BALLOC_NEWLIBGLOBS),$(BALLOC_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,z180,-mz180,$(BALLOC_NEWLIBGLOBS),$(BALLOC_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,ez80_z80,-mez80_z80,$(BALLOC_NEWLIBGLOBS),$(BALLOC_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,kc160,-mkc160,$(BALLOC_NEWLIBGLOBS),$(BALLOC_NEWLIBGLOBS_ex)))

alloc/balloc/obj/%:
	@mkdir -p $@

alloc-balloc-clean:
	$(RM) -fr alloc/balloc/obj alloc/balloc/*.o
	
