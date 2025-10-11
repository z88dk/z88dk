STRING_GLOBS := "$(NEWLIB_DIRECTORY)/string/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/string/z80/*.asm"
STRING_GLOBS_ex := $(NEWLIB_DIRECTORY)/string/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/string/z80/*.asm

STRING_TARGETS := _DEVELOPMENT/string/obj/newlib-z80-_DEVELOPMENT-string \
		_DEVELOPMENT/string/obj/newlib-z80n-_DEVELOPMENT-string \
		_DEVELOPMENT/string/obj/newlib-r2ka-_DEVELOPMENT-string \
		_DEVELOPMENT/string/obj/newlib-ixiy-_DEVELOPMENT-string \
		_DEVELOPMENT/string/obj/newlib-8080-_DEVELOPMENT-string \
		_DEVELOPMENT/string/obj/newlib-8085-_DEVELOPMENT-string \
		_DEVELOPMENT/string/obj/newlib-gbz80-_DEVELOPMENT-string \
		_DEVELOPMENT/string/obj/newlib-ez80_z80-_DEVELOPMENT-string \
		_DEVELOPMENT/string/obj/newlib-z180-_DEVELOPMENT-string \
		_DEVELOPMENT/string/obj/newlib-r4k-_DEVELOPMENT-string \
		_DEVELOPMENT/string/obj/newlib-kc160-_DEVELOPMENT-string

OBJS += $(STRING_TARGETS)
CLEAN += string-clean

string: $(STRING_OBJS) $(STRING_TARGETS)

.PHONY: string string-clean

$(eval $(call buildnew,_DEVELOPMENT/string,z80,-mz80,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/string,r2ka,-mr2ka,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/string,r4k,-mr4k,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/string,z80n,-mz80n,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/string,ixiy,-mz80 -IXIY,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/string,8080,-m8080,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/string,8085,-m8085,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/string,gbz80,-mgbz80,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/string,z180,-mz180,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/string,ez80_z80,-mez80_z80,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/string,kc160,-mkc160,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))


string-clean:
	$(RM) -fr _DEVELOPMENT/string/obj 
