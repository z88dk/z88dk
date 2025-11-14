APLIB_GLOBS := "compress/aplib//c/sccz80/*.asm" "compress/aplib//z80/*.asm"
APLIB_GLOBS_ex := compress/aplib//c/sccz80/*.asm compress/aplib//z80/*.asm

APLIB_8080_GLOBS := "compress/aplib//c/sccz80/*.asm" "compress/aplib//8080/*.asm"
APLIB_8080_GLOBS_ex := compress/aplib//c/sccz80/*.asm compress/aplib//8080/*.asm

APLIB_TARGETS := compress/aplib/obj/newlib-z80-compress-aplib \
	compress/aplib/obj/newlib-z80n-compress-aplib \
	compress/aplib/obj/newlib-ixiy-compress-aplib \
	compress/aplib/obj/newlib-8080-compress-aplib \
	compress/aplib/obj/newlib-8085-compress-aplib \
	compress/aplib/obj/newlib-gbz80-compress-aplib \
	compress/aplib/obj/newlib-ez80_z80-compress-aplib \
	compress/aplib/obj/newlib-z180-compress-aplib \
	compress/aplib/obj/newlib-kc160-compress-aplib

OBJS += $(APLIB_TARGETS)
CLEAN += compress-aplib-clean

compress-aplib: $(APLIB_TARGETS)

.PHONY: compress-aplib compress-aplib-clean

$(eval $(call buildnew,compress/aplib,z80,-mz80,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,compress/aplib,r2ka,-mr2ka,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,compress/aplib,r4k,-mr4k,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,compress/aplib,z80n,-mz80n,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,compress/aplib,ixiy,-mz80 -IXIY,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,compress/aplib,8080,-m8080,$(APLIB_8080_GLOBS),$(APLIB_8080_GLOBS_ex)))
$(eval $(call buildnew,compress/aplib,8085,-m8085,$(APLIB_8080_GLOBS),$(APLIB_8080_GLOBS_ex)))
$(eval $(call buildnew,compress/aplib,gbz80,-mgbz80,$(APLIB_8080_GLOBS),$(APLIB_8080_GLOBS_ex)))
$(eval $(call buildnew,compress/aplib,z180,-mz180,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,compress/aplib,ez80_z80,-mez80_z80,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,compress/aplib,kc160,-mkc160,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))


compress-aplib-clean:
	$(RM) -fr compress/aplib/obj 
