CTYPE_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/ctype/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/ctype/z80/*.asm"
CTYPE_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/ctype/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/ctype/z80/*.asm

CTYPE_NEWLIB_TARGETS := ctype/obj/newlib-z80-ctype \
		ctype/obj/newlib-z80n-ctype \
		ctype/obj/newlib-r2ka-ctype \
		ctype/obj/newlib-ixiy-ctype \
		ctype/obj/newlib-8080-ctype \
		ctype/obj/newlib-gbz80-ctype \
		ctype/obj/newlib-z180-ctype \
		ctype/obj/newlib-r4k-ctype \
		ctype/obj/newlib-kc160-ctype \
		ctype/obj/newlib-ez80_z80-ctype 
		

OBJS += $(CTYPE_NEWLIB_TARGETS)
CLEAN += ctype-clean

ctype: $(CTYPE_NEWLIB_TARGETS)

.PHONY: ctype ctype-clean

$(eval $(call buildnew,ctype,z80,-mz80,$(CTYPE_NEWLIBGLOBS),$(CTYPE_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,ctype,r2ka,-mr2ka,$(CTYPE_NEWLIBGLOBS),$(CTYPE_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,ctype,r4k,-mr4k,$(CTYPE_NEWLIBGLOBS),$(CTYPE_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,ctype,z80n,-mz80n,$(CTYPE_NEWLIBGLOBS),$(CTYPE_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,ctype,ixiy,-mz80 -IXIY,$(CTYPE_NEWLIBGLOBS),$(CTYPE_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,ctype,8080,-m8080,$(CTYPE_NEWLIBGLOBS),$(CTYPE_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,ctype,gbz80,-mgbz80,$(CTYPE_NEWLIBGLOBS),$(CTYPE_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,ctype,z180,-mz180,$(CTYPE_NEWLIBGLOBS),$(CTYPE_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,ctype,ez80_z80,-mez80_z80,$(CTYPE_NEWLIBGLOBS),$(CTYPE_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,ctype,kc160,-mkc160,$(CTYPE_NEWLIBGLOBS),$(CTYPE_NEWLIBGLOBS_ex)))

ctype-clean:
	$(RM) -fr ctype/obj
