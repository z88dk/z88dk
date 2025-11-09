

OBSTACK_GLOBS := "alloc/obstack/c/sccz80/*.asm" "alloc/obstack/z80/*.asm"
OBSTACK_GLOBS_ex := alloc/obstack/c/sccz80/*.asm alloc/obstack/z80/*.asm


OBSTACK_TARGETS := alloc/obstack/obj/newlib-z80-alloc-obstack \
		alloc/obstack/obj/newlib-z80n-alloc-obstack \
		alloc/obstack/obj/newlib-r2ka-alloc-obstack \
		alloc/obstack/obj/newlib-ixiy-alloc-obstack \
		alloc/obstack/obj/newlib-8080-alloc-obstack \
		alloc/obstack/obj/newlib-8085-alloc-obstack \
		alloc/obstack/obj/newlib-ez80_z80-alloc-obstack \
		alloc/obstack/obj/newlib-z180-alloc-obstack \
		alloc/obstack/obj/newlib-r4k-alloc-obstack \
		alloc/obstack/obj/newlib-kc160-alloc-obstack


OBJS += $(OBSTACK_TARGETS)
CLEAN += alloc-obstack-clean

alloc-obstack: $(OBSTACK_OBJS) $(OBSTACK_TARGETS)

.PHONY: alloc-obstack alloc-obstack-clean

$(eval $(call buildnew,alloc/obstack,z80,-mz80,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,r2ka,-mr2ka,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,r4k,-mr4k,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,z80n,-mz80n,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,ixiy,-mz80 -IXIY,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,8080,-m8080,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,8085,-m8085,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,gbz80,-mgbz80,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,z180,-mz180,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,ez80_z80,-mez80_z80,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))
$(eval $(call buildnew,alloc/obstack,kc160,-mkc160,$(OBSTACK_GLOBS),$(OBSTACK_GLOBS_ex)))

alloc-obstack-clean:
	$(RM) -fr alloc/obstack/obj 
	
