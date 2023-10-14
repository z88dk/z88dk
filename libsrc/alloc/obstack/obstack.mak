
OBSTACK_CFILES := $(notdir $(wildcard alloc/obstack/*.c))
OBSTACK_AFILES := $(notdir $(wildcard alloc/obstack/*.asm))

OBSTACK_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/alloc/obstack/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/alloc/obstack/z80/*.asm"
OBSTACK_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/alloc/obstack/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/alloc/obstack/z80/*.asm


OBSTACK_NEWLIB_TARGETS := alloc/obstack/obj/newlib-z80-alloc-obstack \
		alloc/obstack/obj/newlib-z80n-alloc-obstack \
		alloc/obstack/obj/newlib-r2ka-alloc-obstack \
		alloc/obstack/obj/newlib-ixiy-alloc-obstack \
		alloc/obstack/obj/newlib-8080-alloc-obstack \
		alloc/obstack/obj/newlib-ez80_z80-alloc-obstack \
		alloc/obstack/obj/newlib-z180-alloc-obstack \
		alloc/obstack/obj/newlib-r4k-alloc-obstack \
		alloc/obstack/obj/newlib-kc160-alloc-obstack

OBSTACK_OBJECTS := $(OBSTACK_CFILES:.c=.o) $(OBSTACK_AFILES:.asm=.o)

OBSTACK_OBJS := $(addprefix alloc/obstack/obj/z80/, $(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/r2ka/,$(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/ixiy/,$(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/z80n/,$(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/r4k/,$(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/8080/,$(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/z180/,$(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/ez80_z80/,$(OBSTACK_OBJECTS)) \
	$(addprefix alloc/obstack/obj/kc160/,$(OBSTACK_OBJECTS))


OBJS += $(OBSTACK_OBJS) $(OBSTACK_NEWLIB_TARGETS)
CLEAN += alloc-obstack-clean

alloc-obstack: $(OBSTACK_OBJS) $(OBSTACK_NEWLIB_TARGETS)

.PHONY: alloc-obstack alloc-obstack-clean

$(eval $(call buildbit,alloc/obstack,z80,test))
$(eval $(call buildbit,alloc/obstack,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,alloc/obstack,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,alloc/obstack,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,alloc/obstack,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,alloc/obstack,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,alloc/obstack,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,alloc/obstack,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,alloc/obstack,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,alloc/obstack,kc160,test,-clib=kc160,-mkc160))

$(eval $(call buildnew,alloc/obstack,z80,-mz80,$(OBSTACK_NEWLIBGLOBS),$(OBSTACK_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,r2ka,-mr2ka,$(OBSTACK_NEWLIBGLOBS),$(OBSTACK_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,r4k,-mr4k,$(OBSTACK_NEWLIBGLOBS),$(OBSTACK_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,z80n,-mz80n,$(OBSTACK_NEWLIBGLOBS),$(OBSTACK_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,ixiy,-mz80 -IXIY,$(OBSTACK_NEWLIBGLOBS),$(OBSTACK_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,8080,-m8080,$(OBSTACK_NEWLIBGLOBS),$(OBSTACK_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,gbz80,-mgbz80,$(OBSTACK_NEWLIBGLOBS),$(OBSTACK_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,z180,-mz180,$(OBSTACK_NEWLIBGLOBS),$(OBSTACK_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,ez80_z80,-mez80_z80,$(OBSTACK_NEWLIBGLOBS),$(OBSTACK_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,kc160,-mkc160,$(OBSTACK_NEWLIBGLOBS),$(OBSTACK_NEWLIBGLOBS_ex)))

alloc-obstack-clean:
	$(RM) -fr alloc/obstack/obj alloc/obstack/*.o
	
