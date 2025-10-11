SETJMP_GLOBS := "$(NEWLIB_DIRECTORY)/setjmp/c/*.asm" 
SETJMP_GLOBS_ex := $(NEWLIB_DIRECTORY)/setjmp/c/*.asm

SETJMP_TARGETS := _DEVELOPMENT/setjmp/obj/newlib-z80-_DEVELOPMENT-setjmp \
		_DEVELOPMENT/setjmp/obj/newlib-z80n-_DEVELOPMENT-setjmp \
		_DEVELOPMENT/setjmp/obj/newlib-r2ka-_DEVELOPMENT-setjmp \
		_DEVELOPMENT/setjmp/obj/newlib-ixiy-_DEVELOPMENT-setjmp \
		_DEVELOPMENT/setjmp/obj/newlib-8080-_DEVELOPMENT-setjmp \
		_DEVELOPMENT/setjmp/obj/newlib-8085-_DEVELOPMENT-setjmp \
		_DEVELOPMENT/setjmp/obj/newlib-gbz80-_DEVELOPMENT-setjmp \
		_DEVELOPMENT/setjmp/obj/newlib-z180-_DEVELOPMENT-setjmp \
		_DEVELOPMENT/setjmp/obj/newlib-r4k-_DEVELOPMENT-setjmp \
		_DEVELOPMENT/setjmp/obj/newlib-kc160-_DEVELOPMENT-setjmp \
		_DEVELOPMENT/setjmp/obj/newlib-ez80_z80-_DEVELOPMENT-setjmp 
		

OBJS += $(SETJMP_TARGETS)
CLEAN += setjmp-clean

setjmp: $(SETJMP_TARGETS)

.PHONY: setjmp setjmp-clean

$(eval $(call buildnew,_DEVELOPMENT/setjmp,z80,-mz80,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/setjmp,r2ka,-mr2ka,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/setjmp,r4k,-mr4k,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/setjmp,z80n,-mz80n,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/setjmp,ixiy,-mz80 -IXIY,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/setjmp,8080,-m8080,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/setjmp,8085,-m8085,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/setjmp,gbz80,-mgbz80,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/setjmp,z180,-mz180,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/setjmp,ez80_z80,-mez80_z80,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/setjmp,kc160,-mkc160,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))

setjmp-clean:
	$(RM) -fr $(NEWLIB_DIRECTORY)/setjmp/obj
