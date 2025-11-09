

BALLOC_GLOBS := "alloc/balloc/c/sccz80/*.asm" "alloc/balloc/z80/*.asm" "alloc/balloc/c/classic/*.asm" 
BALLOC_GLOBS_ex := alloc/balloc/c/sccz80/*.asm alloc/balloc/z80/*.asm alloc/balloc/c/classic/*.asm 

BALLOC_TARGETS := alloc/balloc/obj/newlib-z80-alloc-balloc \
		alloc/balloc/obj/newlib-z80n-alloc-balloc \
		alloc/balloc/obj/newlib-r2ka-alloc-balloc \
		alloc/balloc/obj/newlib-ixiy-alloc-balloc \
		alloc/balloc/obj/newlib-z180-alloc-balloc \
		alloc/balloc/obj/newlib-ez80_z80-alloc-balloc \
		alloc/balloc/obj/newlib-r4k-alloc-balloc \
		alloc/balloc/obj/newlib-kc160-alloc-balloc 


OBJS += $(BALLOC_TARGETS)
CLEAN += alloc-balloc-clean

alloc-balloc: $(BALLOC_OBJS) $(BALLOC_TARGETS)

.PHONY: alloc-balloc alloc-balloc-clean

$(eval $(call buildnew,alloc/balloc,z80,-mz80,$(BALLOC_GLOBS),$(BALLOC_GLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,r2ka,-mr2ka,$(BALLOC_GLOBS),$(BALLOC_GLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,r4k,-mr4k,$(BALLOC_GLOBS),$(BALLOC_GLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,z80n,-mz80n,$(BALLOC_GLOBS),$(BALLOC_GLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,ixiy,-mz80 -IXIY,$(BALLOC_GLOBS),$(BALLOC_GLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,z180,-mz180,$(BALLOC_GLOBS),$(BALLOC_GLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,ez80_z80,-mez80_z80,$(BALLOC_GLOBS),$(BALLOC_GLOBS_ex)))
$(eval $(call buildnew,alloc/balloc,kc160,-mkc160,$(BALLOC_GLOBS),$(BALLOC_GLOBS_ex)))


alloc-balloc-clean:
	$(RM) -fr alloc/balloc/obj 
	
