STRING_GLOBS := "string/c/sccz80/*.asm" "string/z80/*.asm"
STRING_GLOBS_ex := string/c/sccz80/*.asm string/z80/*.asm

STRING_TARGETS := string/obj/newlib-z80-string \
		string/obj/newlib-z80n-string \
		string/obj/newlib-r2ka-string \
		string/obj/newlib-ixiy-string \
		string/obj/newlib-8080-string \
		string/obj/newlib-8085-string \
		string/obj/newlib-gbz80-string \
		string/obj/newlib-ez80_z80-string \
		string/obj/newlib-z180-string \
		string/obj/newlib-r4k-string \
		string/obj/newlib-kc160-string

OBJS += $(STRING_TARGETS)
CLEAN += string-clean

string: $(STRING_OBJS) $(STRING_TARGETS)

.PHONY: string string-clean

$(eval $(call buildnew,string,z80,-mz80,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,string,r2ka,-mr2ka,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,string,r4k,-mr4k,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,string,z80n,-mz80n,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,string,ixiy,-mz80 -IXIY,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,string,8080,-m8080,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,string,8085,-m8085,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,string,gbz80,-mgbz80,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,string,z180,-mz180,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,string,ez80_z80,-mez80_z80,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))
$(eval $(call buildnew,string,kc160,-mkc160,$(STRING_GLOBS),$(CTYPE_GLOBS_ex)))


string-clean:
	$(RM) -fr string/obj 
