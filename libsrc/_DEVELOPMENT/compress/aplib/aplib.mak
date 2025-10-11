APLIB_GLOBS := "$(NEWLIB_DIRECTORY)/compress/aplib//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/aplib//z80/*.asm"
APLIB_GLOBS_ex := $(NEWLIB_DIRECTORY)/compress/aplib//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/aplib//z80/*.asm

APLIB_8080_GLOBS := "$(NEWLIB_DIRECTORY)/compress/aplib//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/aplib//8080/*.asm"
APLIB_8080_GLOBS_ex := $(NEWLIB_DIRECTORY)/compress/aplib//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/aplib//8080/*.asm

APLIB_TARGETS := _DEVELOPMENT/compress/aplib/obj/newlib-z80-compress-aplib \
	_DEVELOPMENT/compress/aplib/obj/newlib-z80n-compress-aplib \
	_DEVELOPMENT/compress/aplib/obj/newlib-ixiy-compress-aplib \
	_DEVELOPMENT/compress/aplib/obj/newlib-8080-compress-aplib \
	_DEVELOPMENT/compress/aplib/obj/newlib-8085-compress-aplib \
	_DEVELOPMENT/compress/aplib/obj/newlib-gbz80-compress-aplib \
	_DEVELOPMENT/compress/aplib/obj/newlib-ez80_z80-compress-aplib \
	_DEVELOPMENT/compress/aplib/obj/newlib-z180-compress-aplib \
	_DEVELOPMENT/compress/aplib/obj/newlib-kc160-compress-aplib

OBJS += $(APLIB_TARGETS)
CLEAN += compress-aplib-clean

compress-aplib: $(APLIB_TARGETS)

.PHONY: compress-aplib compress-aplib-clean

$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,z80,-mz80,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,r2ka,-mr2ka,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,r4k,-mr4k,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,z80n,-mz80n,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,ixiy,-mz80 -IXIY,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,8080,-m8080,$(APLIB_8080_GLOBS),$(APLIB_8080_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,8085,-m8085,$(APLIB_8080_GLOBS),$(APLIB_8080_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,gbz80,-mgbz80,$(APLIB_8080_GLOBS),$(APLIB_8080_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,z180,-mz180,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,ez80_z80,-mez80_z80,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/compress/aplib,kc160,-mkc160,$(APLIB_GLOBS),$(APLIB_GLOBS_ex)))


compress-aplib-clean:
	$(RM) -fr _DEVELOPMENT/compress/aplib/obj 
