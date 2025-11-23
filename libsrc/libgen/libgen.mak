LIBGEN_GLOBS := "libgen/c/sccz80/*.asm" "libgen/z80/*.asm"
LIBGEN_GLOBS_ex := libgen/c/sccz80/*.asm libgen/z80/*.asm

LIBGEN_TARGETS := libgen/obj/newlib-z80-libgen \
		libgen/obj/newlib-z80n-libgen \
		libgen/obj/newlib-r2ka-libgen \
		libgen/obj/newlib-ixiy-libgen \
		libgen/obj/newlib-8080-libgen \
		libgen/obj/newlib-8085-libgen \
		libgen/obj/newlib-gbz80-libgen \
		libgen/obj/newlib-r4k-libgen \
		libgen/obj/newlib-z180-libgen \
		libgen/obj/newlib-kc160-libgen \
		libgen/obj/newlib-ez80_z80-libgen

OBJS += $(LIBGEN_TARGETS)
CLEAN += libgen-clean

libgen: $(LIBGEN_TARGETS)

.PHONY: libgen libgen-clean

$(eval $(call buildnew,libgen,z80,-mz80,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,libgen,r2ka,-mr2ka,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,libgen,r4k,-mr4k,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,libgen,z80n,-mz80n,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,libgen,ixiy,-mz80 -IXIY,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,libgen,8080,-m8080,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,libgen,8085,-m8085,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,libgen,gbz80,-mgbz80,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,libgen,z180,-mz180,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,libgen,ez80_z80,-mez80_z80,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))
$(eval $(call buildnew,libgen,kc160,-mkc160,$(LIBGEN_GLOBS),$(LIBGEN_GLOBS_ex)))

libgen-clean:
	$(RM) -fr libgen/obj
