FONT8x8_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/font/font_8x8/*.asm"
FONT8x8_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/font/font_8x8/*.asm

FONT8x8_NEWLIB_TARGETS := font/font_8x8/obj/newlib-z80-font-font_8x8 \
	font/font_8x8/obj/newlib-r2ka-font-font_8x8 \
	font/font_8x8/obj/newlib-r4k-font-font_8x8 \
	font/font_8x8/obj/newlib-z80n-font-font_8x8 \
	font/font_8x8/obj/newlib-ixiy-font-font_8x8 \
	font/font_8x8/obj/newlib-8080-font-font_8x8 \
	font/font_8x8/obj/newlib-gbz80-font-font_8x8 \
	font/font_8x8/obj/newlib-z180-font-font_8x8 \
	font/font_8x8/obj/newlib-ez80_z80-font-font_8x8 \
	font/font_8x8/obj/newlib-kc160-font-font_8x8

OBJS += $(FONT8x8_NEWLIB_TARGETS)
CLEAN += font_8x8-clean

font_8x8: $(FONT8x8_NEWLIB_TARGETS)

.PHONY: font_8x8 font_8x8-clean

$(eval $(call buildnew,font/font_8x8,z80,-mz80 -I$(NEWLIB_DIRECTORY),$(FONT8x8_NEWLIBGLOBS),$(FONT8x8_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/font_8x8,r2ka,-mr2ka -I$(NEWLIB_DIRECTORY),$(FONT8x8_NEWLIBGLOBS),$(FONT8x8_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/font_8x8,r4k,-mr4k -I$(NEWLIB_DIRECTORY),$(FONT8x8_NEWLIBGLOBS),$(FONT8x8_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/font_8x8,z80n,-mz80n -I$(NEWLIB_DIRECTORY),$(FONT8x8_NEWLIBGLOBS),$(FONT8x8_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/font_8x8,ixiy,-mz80 -IXIY -I$(NEWLIB_DIRECTORY),$(FONT8x8_NEWLIBGLOBS),$(FONT8x8_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/font_8x8,8080,-m8080 -I$(NEWLIB_DIRECTORY),$(FONT8x8_NEWLIBGLOBS),$(FONT8x8_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/font_8x8,gbz80,-mgbz80 -I$(NEWLIB_DIRECTORY),$(FONT8x8_NEWLIBGLOBS),$(FONT8x8_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/font_8x8,z180,-mz180 -I$(NEWLIB_DIRECTORY),$(FONT8x8_NEWLIBGLOBS),$(FONT8x8_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/font_8x8,ez80_z80,-mez80_z80 -I$(NEWLIB_DIRECTORY),$(FONT8x8_NEWLIBGLOBS),$(FONT8x8_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/font_8x8,kc160,-mkc160 -I$(NEWLIB_DIRECTORY),$(FONT8x8_NEWLIBGLOBS),$(FONT8x8_NEWLIBGLOBS_ex)))

font_8x8-clean:
	$(RM) -fr font/font_8x8/obj
