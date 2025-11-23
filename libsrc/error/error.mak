ERROR_GLOBS := "error/z80/*.asm"
ERROR_GLOBS_ex := error/z80/*.asm

ERROR_TARGETS := error/obj/newlib-z80-error \
		error/obj/newlib-z80n-error \
		error/obj/newlib-r2ka-error \
		error/obj/newlib-ixiy-error \
		error/obj/newlib-8080-error \
		error/obj/newlib-8085-error \
		error/obj/newlib-gbz80-error \
		error/obj/newlib-z180-error \
		error/obj/newlib-r4k-error \
		error/obj/newlib-kc160-error \
		error/obj/newlib-ez80_z80-error 
		

OBJS += $(ERROR_TARGETS)
CLEAN += error-clean

error: $(ERROR_TARGETS)

.PHONY: error error-clean

$(eval $(call buildnew,error,z80,-mz80,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))
$(eval $(call buildnew,error,r2ka,-mr2ka,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))
$(eval $(call buildnew,error,r4k,-mr4k,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))
$(eval $(call buildnew,error,z80n,-mz80n,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))
$(eval $(call buildnew,error,ixiy,-mz80 -IXIY,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))
$(eval $(call buildnew,error,8080,-m8080,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))
$(eval $(call buildnew,error,8085,-m8085,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))
$(eval $(call buildnew,error,gbz80,-mgbz80,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))
$(eval $(call buildnew,error,z180,-mz180,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))
$(eval $(call buildnew,error,ez80_z80,-mez80_z80,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))
$(eval $(call buildnew,error,kc160,-mkc160,$(ERROR_GLOBS),$(ERROR_GLOBS_ex)))

error-clean:
	$(RM) -fr error/obj
