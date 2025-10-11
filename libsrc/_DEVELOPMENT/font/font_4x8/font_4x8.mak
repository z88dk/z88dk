FONT4x8_GLOBS := "$(NEWLIB_DIRECTORY)/font/font_4x8/*.asm"
FONT4x8_GLOBS_ex := $(NEWLIB_DIRECTORY)/font/font_4x8/*.asm

FONT4x8_TARGETS := _DEVELOPMENT/font/font_4x8/obj/newlib-z80-font-font_4x8 \
	_DEVELOPMENT/font/font_4x8/obj/newlib-r2ka-font-font_4x8 \
	_DEVELOPMENT/font/font_4x8/obj/newlib-r4k-font-font_4x8 \
	_DEVELOPMENT/font/font_4x8/obj/newlib-z80n-font-font_4x8 \
	_DEVELOPMENT/font/font_4x8/obj/newlib-ixiy-font-font_4x8 \
	_DEVELOPMENT/font/font_4x8/obj/newlib-8080-font-font_4x8 \
	_DEVELOPMENT/font/font_4x8/obj/newlib-8085-font-font_4x8 \
	_DEVELOPMENT/font/font_4x8/obj/newlib-gbz80-font-font_4x8 \
	_DEVELOPMENT/font/font_4x8/obj/newlib-z180-font-font_4x8 \
	_DEVELOPMENT/font/font_4x8/obj/newlib-ez80_z80-font-font_4x8 \
	_DEVELOPMENT/font/font_4x8/obj/newlib-kc160-font-font_4x8

OBJS += $(FONT4x8_TARGETS)
CLEAN += font_4x8-clean

font_4x8: $(FONT4x8_TARGETS)

.PHONY: font_4x8 font_4x8-clean

$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,z80,-mz80 -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,r2ka,-mr2ka -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,r4k,-mr4k -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,z80n,-mz80n -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,ixiy,-mz80 -IXIY -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,8080,-m8080 -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,8085,-m8085 -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,gbz80,-mgbz80 -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,z180,-mz180 -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,ez80_z80,-mez80_z80 -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/font_4x8,kc160,-mkc160 -I$(NEWLIB_DIRECTORY),$(FONT4x8_GLOBS),$(FONT4x8_GLOBS_ex)))


font_4x8-clean:
	$(RM) -fr _DEVELOPMENT/font/font_4x8/obj
