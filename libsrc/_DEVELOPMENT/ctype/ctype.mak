CTYPE_GLOBS := "$(NEWLIB_DIRECTORY)/ctype/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/ctype/z80/*.asm"
CTYPE_GLOBS_ex := $(NEWLIB_DIRECTORY)/ctype/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/ctype/z80/*.asm

CTYPE_TARGETS := _DEVELOPMENT/ctype/obj/newlib-z80-ctype \
		_DEVELOPMENT/ctype/obj/newlib-z80n-ctype \
		_DEVELOPMENT/ctype/obj/newlib-r2ka-ctype \
		_DEVELOPMENT/ctype/obj/newlib-ixiy-ctype \
		_DEVELOPMENT/ctype/obj/newlib-8080-ctype \
		_DEVELOPMENT/ctype/obj/newlib-8085-ctype \
		_DEVELOPMENT/ctype/obj/newlib-gbz80-ctype \
		_DEVELOPMENT/ctype/obj/newlib-z180-ctype \
		_DEVELOPMENT/ctype/obj/newlib-r4k-ctype \
		_DEVELOPMENT/ctype/obj/newlib-kc160-ctype \
		_DEVELOPMENT/ctype/obj/newlib-ez80_z80-ctype 
		

OBJS += $(CTYPE_TARGETS)
CLEAN += ctype-clean

_DEVELOPMENT/ctype: $(CTYPE_TARGETS)

.PHONY: ctype ctype-clean

$(eval $(call buildnew,_DEVELOPMENT/ctype,z80,-mz80,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/ctype,r2ka,-mr2ka,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/ctype,r4k,-mr4k,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/ctype,z80n,-mz80n,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/ctype,ixiy,-mz80 -IXIY,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/ctype,8080,-m8080,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/ctype,8085,-m8085,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/ctype,gbz80,-mgbz80,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/ctype,z180,-mz180,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/ctype,ez80_z80,-mez80_z80,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/ctype,kc160,-mkc160,$(CTYPE_GLOBS),$(CTYPE_GLOBS_ex)))

ctype-clean:
	$(RM) -fr _DEVELOPMENT/ctype/obj
