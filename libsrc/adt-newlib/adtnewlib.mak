ADT_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/adt/*/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/adt/*/z80/*.asm"
ADT_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/adt/*/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/adt/*/z80/*.asm

ADT_NEWLIB_TARGETS := adt-newlib/obj/newlib-z80-adt-newlib \
	adt-newlib/obj/newlib-z80n-adt-newlib \
	adt-newlib/obj/newlib-r2ka-adt-newlib \
	adt-newlib/obj/newlib-r4k-adt-newlib \
	adt-newlib/obj/newlib-ixiy-adt-newlib \
	adt-newlib/obj/newlib-z180-adt-newlib \
	adt-newlib/obj/newlib-ez80_z80-adt-newlib \
	adt-newlib/obj/newlib-kc160-adt-newlib  

OBJS += $(ADT_NEWLIB_TARGETS)
CLEAN += adt-newlib-clean

adt-newlib: $(ADT_NEWLIB_TARGETS)

.PHONY: adt-newlib adt-newlib-clean

$(eval $(call buildnew,adt-newlib,z80,-mz80,$(ADT_NEWLIBGLOBS),$(ADT_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,adt-newlib,r2ka,-mr2ka,$(ADT_NEWLIBGLOBS),$(ADT_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,adt-newlib,r4k,-mr4k,$(ADT_NEWLIBGLOBS),$(ADT_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,adt-newlib,z80n,-mz80n,$(ADT_NEWLIBGLOBS),$(ADT_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,adt-newlib,ixiy,-mz80 -IXIY,$(ADT_NEWLIBGLOBS),$(ADT_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,adt-newlib,z180,-mz180,$(ADT_NEWLIBGLOBS),$(ADT_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,adt-newlib,ez80_z80,-mez80_z80,$(ADT_NEWLIBGLOBS),$(ADT_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,adt-newlib,kc160,-mkc160,$(ADT_NEWLIBGLOBS),$(ADT_NEWLIBGLOBS_ex)))


adt-newlib-clean:
	$(RM) -fr adt-newlib/obj
