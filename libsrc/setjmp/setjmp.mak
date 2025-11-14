SETJMP_GLOBS := "setjmp/c/*.asm" 
SETJMP_GLOBS_ex := setjmp/c/*.asm

SETJMP_TARGETS := setjmp/obj/newlib-z80-setjmp \
		setjmp/obj/newlib-z80n-setjmp \
		setjmp/obj/newlib-r2ka-setjmp \
		setjmp/obj/newlib-ixiy-setjmp \
		setjmp/obj/newlib-8080-setjmp \
		setjmp/obj/newlib-8085-setjmp \
		setjmp/obj/newlib-gbz80-setjmp \
		setjmp/obj/newlib-z180-setjmp \
		setjmp/obj/newlib-r4k-setjmp \
		setjmp/obj/newlib-kc160-setjmp \
		setjmp/obj/newlib-ez80_z80-setjmp 
		

OBJS += $(SETJMP_TARGETS)
CLEAN += setjmp-clean

setjmp: $(SETJMP_TARGETS)

.PHONY: setjmp setjmp-clean

$(eval $(call buildnew,setjmp,z80,-mz80,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,setjmp,r2ka,-mr2ka,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,setjmp,r4k,-mr4k,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,setjmp,z80n,-mz80n,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,setjmp,ixiy,-mz80 -IXIY,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,setjmp,8080,-m8080,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,setjmp,8085,-m8085,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,setjmp,gbz80,-mgbz80,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,setjmp,z180,-mz180,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,setjmp,ez80_z80,-mez80_z80,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))
$(eval $(call buildnew,setjmp,kc160,-mkc160,$(SETJMP_GLOBS),$(SETJMP_GLOBS_ex)))

setjmp-clean:
	$(RM) -fr setjmp/obj
