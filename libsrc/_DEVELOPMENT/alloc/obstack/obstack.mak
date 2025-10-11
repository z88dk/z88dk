

OBSTACK_GLOBS := "$(NEWLIB_DIRECTORY)/alloc/obstack/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/alloc/obstack/z80/*.asm"
OBSTACK_GLOBS_ex := $(NEWLIB_DIRECTORY)/alloc/obstack/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/alloc/obstack/z80/*.asm


OBSTACK_TARGETS := _DEVELOPMENT/alloc/obstack/obj/newlib-z80-alloc-obstack \
		_DEVELOPMENT/alloc/obstack/obj/newlib-z80n-alloc-obstack \
		_DEVELOPMENT/alloc/obstack/obj/newlib-r2ka-alloc-obstack \
		_DEVELOPMENT/alloc/obstack/obj/newlib-ixiy-alloc-obstack \
		_DEVELOPMENT/alloc/obstack/obj/newlib-8080-alloc-obstack \
		_DEVELOPMENT/alloc/obstack/obj/newlib-8085-alloc-obstack \
		_DEVELOPMENT/alloc/obstack/obj/newlib-ez80_z80-alloc-obstack \
		_DEVELOPMENT/alloc/obstack/obj/newlib-z180-alloc-obstack \
		_DEVELOPMENT/alloc/obstack/obj/newlib-r4k-alloc-obstack \
		_DEVELOPMENT/alloc/obstack/obj/newlib-kc160-alloc-obstack


OBJS += $(OBSTACK_TARGETS)
CLEAN += alloc-obstack-clean

alloc-obstack: $(OBSTACK_OBJS) $(OBSTACK_TARGETS)

.PHONY: alloc-obstack alloc-obstack-clean

$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,z80,-mz80,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,r2ka,-mr2ka,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,r4k,-mr4k,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,z80n,-mz80n,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,ixiy,-mz80 -IXIY,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,8080,-m8080,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,8085,-m8085,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,gbz80,-mgbz80,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,z180,-mz180,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,ez80_z80,-mez80_z80,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/alloc/obstack,kc160,-mkc160,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))

alloc-obstack-clean:
	$(RM) -fr _DEVELOPMENT/alloc/obstack/obj 
	
