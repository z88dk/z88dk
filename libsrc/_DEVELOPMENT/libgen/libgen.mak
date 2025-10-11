LIBGEN_GLOBS := "$(NEWLIB_DIRECTORY)/libgen/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/libgen/z80/*.asm"
LIBGEN_GLOBS_ex := $(NEWLIB_DIRECTORY)/libgen/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/libgen/z80/*.asm

LIBGEN_TARGETS := _DEVELOPMENT/libgen/obj/newlib-z80-libgen \
		_DEVELOPMENT/libgen/obj/newlib-z80n-libgen \
		_DEVELOPMENT/libgen/obj/newlib-r2ka-libgen \
		_DEVELOPMENT/libgen/obj/newlib-ixiy-libgen \
		_DEVELOPMENT/libgen/obj/newlib-8080-libgen \
		_DEVELOPMENT/libgen/obj/newlib-8085-libgen \
		_DEVELOPMENT/libgen/obj/newlib-gbz80-libgen \
		_DEVELOPMENT/libgen/obj/newlib-r4k-libgen \
		_DEVELOPMENT/libgen/obj/newlib-z180-libgen \
		_DEVELOPMENT/libgen/obj/newlib-kc160-libgen \
		_DEVELOPMENT/libgen/obj/newlib-ez80_z80-libgen

OBJS += $(LIBGEN_TARGETS)
CLEAN += libgen-clean

libgen: $(LIBGEN_TARGETS)

.PHONY: libgen libgen-clean

$(eval $(call buildnew,_DEVELOPMENT/libgen,z80,-mz80,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/libgen,r2ka,-mr2ka,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/libgen,r4k,-mr4k,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/libgen,z80n,-mz80n,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/libgen,ixiy,-mz80 -IXIY,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/libgen,8080,-m8080,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/libgen,8085,-m8085,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/libgen,gbz80,-mgbz80,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/libgen,z180,-mz180,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/libgen,ez80_z80,-mez80_z80,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/libgen,kc160,-mkc160,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))

libgen-clean:
	$(RM) -fr _DEVELOPMENT/libgen/obj
