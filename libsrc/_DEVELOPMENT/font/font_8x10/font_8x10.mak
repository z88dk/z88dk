FONT8x10_GLOBS := "$(NEWLIB_DIRECTORY)/font/font_8x10/*.asm"
FONT8x10_GLOBS_ex := $(NEWLIB_DIRECTORY)/font/font_8x10/*.asm

FONT8x10_TARGETS := _DEVELOPMENT/font/font_8x10/obj/newlib-z80-font-font_8x10 \
	_DEVELOPMENT/font/font_8x10/obj/newlib-r2ka-font-font_8x10 \
	_DEVELOPMENT/font/font_8x10/obj/newlib-r4k-font-font_8x10 \
	_DEVELOPMENT/font/font_8x10/obj/newlib-z80n-font-font_8x10 \
	_DEVELOPMENT/font/font_8x10/obj/newlib-ixiy-font-font_8x10 \
	_DEVELOPMENT/font/font_8x10/obj/newlib-8080-font-font_8x10 \
	_DEVELOPMENT/font/font_8x10/obj/newlib-8085-font-font_8x10 \
	_DEVELOPMENT/font/font_8x10/obj/newlib-gbz80-font-font_8x10 \
	_DEVELOPMENT/font/font_8x10/obj/newlib-z180-font-font_8x10 \
	_DEVELOPMENT/font/font_8x10/obj/newlib-ez80_z80-font-font_8x10 \
	_DEVELOPMENT/font/font_8x10/obj/newlib-kc160-font-font_8x10

OBJS += $(FONT8x10_TARGETS)
CLEAN += font_8x10-clean

font_8x10: $(FONT8x10_TARGETS)

.PHONY: font_8x10 font_8x10-clean

$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,z80,-mz80 -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,r2ka,-mr2ka -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,r4k,-mr4k -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,z80n,-mz80n -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,ixiy,-mz80 -IXIY -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,8080,-m8080 -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,8085,-m8085 -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,gbz80,-mgbz80 -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,z180,-mz180 -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,ez80_z80,-mez80_z80 -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_8x10,kc160,-mkc160 -I$(NEWLIB_DIRECTORY),$(FONT8x10_GLOBS),$(FONT8x10_GLOBS_ex)))

font_8x10-clean:
	$(RM) -fr _DEVELOPMENT/font/font_8x10/obj
