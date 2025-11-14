ADT_GLOBS := "adt/*/c/sccz80/*.asm" "adt/*/z80/*.asm"
ADT_GLOBS_ex := adt/*/c/sccz80/*.asm adt/*/z80/*.asm

ADT_TARGETS := adt/obj/newlib-z80-adt \
	adt/obj/newlib-z80n-adt \
	adt/obj/newlib-r2ka-adt \
	adt/obj/newlib-r4k-adt \
	adt/obj/newlib-ixiy-adt \
	adt/obj/newlib-z180-adt \
	adt/obj/newlib-ez80_z80-adt \
	adt/obj/newlib-kc160-adt  

OBJS += $(ADT_TARGETS)
CLEAN += adt-clean

adt: $(ADT_TARGETS)

.PHONY: adt adt-clean

$(eval $(call buildnew,adt,z80,-mz80,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,adt,r2ka,-mr2ka,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,adt,r4k,-mr4k,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,adt,z80n,-mz80n,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,adt,ixiy,-mz80 -IXIY,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,adt,z180,-mz180,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,adt,ez80_z80,-mez80_z80,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,adt,kc160,-mkc160,$(ADT_GLOBS),$(ADT_GLOBS_ex)))


adt-clean:
	$(RM) -fr adt/obj
