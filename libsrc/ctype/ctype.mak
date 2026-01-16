CTYPE_GLOBS := "ctype/c/sccz80/*.asm" "ctype/z80/*.asm"
CTYPE_GLOBS_ex := ctype/c/sccz80/*.asm ctype/z80/*.asm

CTYPE_TARGETS := ctype/obj/newlib-z80-ctype \
		ctype/obj/newlib-z80n-ctype \
		ctype/obj/newlib-r2ka-ctype \
		ctype/obj/newlib-ixiy-ctype \
		ctype/obj/newlib-8080-ctype \
		ctype/obj/newlib-8085-ctype \
		ctype/obj/newlib-gbz80-ctype \
		ctype/obj/newlib-z180-ctype \
		ctype/obj/newlib-r4k-ctype \
		ctype/obj/newlib-kc160-ctype \
		ctype/obj/newlib-ez80_z80-ctype 
		

OBJS += $(CTYPE_TARGETS)
CLEAN += ctype-clean

ctype: $(CTYPE_TARGETS)

.PHONY: ctype ctype-clean

$(eval $(call buildnew,ctype,z80,-mz80,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,ctype,r2ka,-mr2ka,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,ctype,r4k,-mr4k,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,ctype,z80n,-mz80n,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,ctype,ixiy,-mz80 -IXIY,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,ctype,8080,-m8080,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,ctype,8085,-m8085,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,ctype,gbz80,-mgbz80,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,ctype,z180,-mz180,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,ctype,ez80_z80,-mez80_z80,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,ctype,kc160,-mkc160,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))

ctype-clean:
	$(RM) -fr ctype/obj
