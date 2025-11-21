LOCALE_GLOBS := "locale/z80/*.asm"
LOCALE_GLOBS_ex := locale/z80/*.asm

LOCALE_TARGETS := locale/obj/newlib-z80-locale \
		locale/obj/newlib-z80n-locale \
		locale/obj/newlib-r2ka-locale \
		locale/obj/newlib-ixiy-locale \
		locale/obj/newlib-8080-locale \
		locale/obj/newlib-8085-locale \
		locale/obj/newlib-gbz80-locale \
		locale/obj/newlib-z180-locale \
		locale/obj/newlib-r4k-locale \
		locale/obj/newlib-kc160-locale \
		locale/obj/newlib-ez80_z80-locale 
		

OBJS += $(LOCALE_TARGETS)
CLEAN += locale-clean

locale: $(LOCALE_TARGETS)

.PHONY: locale locale-clean

$(eval $(call buildnew,locale,z80,-mz80,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))
$(eval $(call buildnew,locale,r2ka,-mr2ka,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))
$(eval $(call buildnew,locale,r4k,-mr4k,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))
$(eval $(call buildnew,locale,z80n,-mz80n,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))
$(eval $(call buildnew,locale,ixiy,-mz80 -IXIY,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))
$(eval $(call buildnew,locale,8080,-m8080,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))
$(eval $(call buildnew,locale,8085,-m8085,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))
$(eval $(call buildnew,locale,gbz80,-mgbz80,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))
$(eval $(call buildnew,locale,z180,-mz180,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))
$(eval $(call buildnew,locale,ez80_z80,-mez80_z80,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))
$(eval $(call buildnew,locale,kc160,-mkc160,$(LOCALE_GLOBS),$(LOCALE_GLOBS_ex)))

locale-clean:
	$(RM) -fr locale/obj
