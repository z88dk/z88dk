INTTYPES_GLOBS := "inttypes/c/sccz80/*.asm" "inttypes/z80/*.asm"
INTTYPES_GLOBS_ex := inttypes/c/sccz80/*.asm inttypes/z80/*.asm

INTTYPES_TARGETS := inttypes/obj/newlib-z80-inttypes \
		inttypes/obj/newlib-z80n-inttypes \
		inttypes/obj/newlib-r2ka-inttypes \
		inttypes/obj/newlib-ixiy-inttypes \
		inttypes/obj/newlib-8080-inttypes \
		inttypes/obj/newlib-8085-inttypes \
		inttypes/obj/newlib-gbz80-inttypes \
		inttypes/obj/newlib-z180-inttypes \
		inttypes/obj/newlib-r4k-inttypes \
		inttypes/obj/newlib-kc160-inttypes \
		inttypes/obj/newlib-ez80_z80-inttypes 
		

OBJS += $(INTTYPES_TARGETS)
CLEAN += inttypes-clean

inttypes: $(INTTYPES_TARGETS)

.PHONY: inttypes inttypes-clean

$(eval $(call buildnew,inttypes,z80,-mz80,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))
$(eval $(call buildnew,inttypes,r2ka,-mr2ka,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))
$(eval $(call buildnew,inttypes,r4k,-mr4k,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))
$(eval $(call buildnew,inttypes,z80n,-mz80n,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))
$(eval $(call buildnew,inttypes,ixiy,-mz80 -IXIY,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))
$(eval $(call buildnew,inttypes,8080,-m8080,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))
$(eval $(call buildnew,inttypes,8085,-m8085,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))
$(eval $(call buildnew,inttypes,gbz80,-mgbz80,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))
$(eval $(call buildnew,inttypes,z180,-mz180,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))
$(eval $(call buildnew,inttypes,ez80_z80,-mez80_z80,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))
$(eval $(call buildnew,inttypes,kc160,-mkc160,$(INTTYPES_GLOBS),$(INTTYPES_GLOBS_ex)))

inttypes-clean:
	$(RM) -fr inttypes/obj
