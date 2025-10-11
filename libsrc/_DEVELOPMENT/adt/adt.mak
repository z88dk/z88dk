ADT_GLOBS := "$(NEWLIB_DIRECTORY)/adt/*/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/adt/*/z80/*.asm"
ADT_GLOBS_ex := $(NEWLIB_DIRECTORY)/adt/*/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/adt/*/z80/*.asm

ADT_TARGETS := _DEVELOPMENT/adt/obj/newlib-z80-adt \
	_DEVELOPMENT/adt/obj/newlib-z80n-adt \
	_DEVELOPMENT/adt/obj/newlib-r2ka-adt \
	_DEVELOPMENT/adt/obj/newlib-r4k-adt \
	_DEVELOPMENT/adt/obj/newlib-ixiy-adt \
	_DEVELOPMENT/adt/obj/newlib-z180-adt \
	_DEVELOPMENT/adt/obj/newlib-ez80_z80-adt \
	_DEVELOPMENT/adt/obj/newlib-kc160-adt  

OBJS += $(ADT_TARGETS)
CLEAN += adt-clean

adt: $(ADT_TARGETS)

.PHONY: adt adt-clean

$(eval $(call buildnew,_DEVELOPMENT/adt,z80,-mz80,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/adt,r2ka,-mr2ka,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/adt,r4k,-mr4k,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/adt,z80n,-mz80n,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/adt,ixiy,-mz80 -IXIY,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/adt,z180,-mz180,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/adt,ez80_z80,-mez80_z80,$(ADT_GLOBS),$(ADT_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/adt,kc160,-mkc160,$(ADT_GLOBS),$(ADT_GLOBS_ex)))


adt-clean:
	$(RM) -fr _DEVELOPMENT/adt/obj
