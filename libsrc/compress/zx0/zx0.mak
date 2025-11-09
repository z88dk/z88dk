ZX0_GLOBS := "compress/zx0//c/sccz80/*.asm" "compress/zx0//z80/*.asm"
ZX0_GLOBS_ex := compress/zx0//c/sccz80/*.asm compress/zx0//z80/*.asm

ZX0_8080_GLOBS := "compress/zx0//c/sccz80/*.asm" "compress/zx0//8080/*.asm"
ZX0_8080_GLOBS_ex := compress/zx0//c/sccz80/*.asm compress/zx0//8080/*.asm

ZX0_TARGETS := compress/zx0/obj/newlib-z80-compress-zx0 \
	compress/zx0/obj/newlib-z80n-compress-zx0 \
	compress/zx0/obj/newlib-ixiy-compress-zx0 \
	compress/zx0/obj/newlib-8080-compress-zx0 \
	compress/zx0/obj/newlib-8085-compress-zx0 \
	compress/zx0/obj/newlib-r2ka-compress-zx0 \
	compress/zx0/obj/newlib-ez80_z80-compress-zx0 \
	compress/zx0/obj/newlib-z180-compress-zx0 \
	compress/zx0/obj/newlib-r4k-compress-zx0 \
	compress/zx0/obj/newlib-kc160-compress-zx0 

OBJS += $(ZX0_TARGETS)
CLEAN += compress-zx0-clean

compress-zx0: $(ZX0_TARGETS)

.PHONY: compress-zx0 compress-zx0-clean

$(eval $(call buildnew,compress/zx0,z80,-mz80,$(ZX0_GLOBS),$(ZX0_GLOBS_ex)))
$(eval $(call buildnew,compress/zx0,r2ka,-mr2ka,$(ZX0_GLOBS),$(ZX0_GLOBS_ex)))
$(eval $(call buildnew,compress/zx0,r4k,-mr4k,$(ZX0_GLOBS),$(ZX0_GLOBS_ex)))
$(eval $(call buildnew,compress/zx0,z80n,-mz80n,$(ZX0_GLOBS),$(ZX0_GLOBS_ex)))
$(eval $(call buildnew,compress/zx0,ixiy,-mz80 -IXIY,$(ZX0_GLOBS),$(ZX0_GLOBS_ex)))
$(eval $(call buildnew,compress/zx0,8080,-m8080,$(ZX0_8080_GLOBS),$(ZX0_8080_GLOBS_ex)))
$(eval $(call buildnew,compress/zx0,8085,-m8085,$(ZX0_8080_GLOBS),$(ZX0_8080_GLOBS_ex)))
$(eval $(call buildnew,compress/zx0,gbz80,-mgbz80,$(ZX0_8080_GLOBS),$(ZX0_8080_GLOBS_ex)))
$(eval $(call buildnew,compress/zx0,z180,-mz180,$(ZX0_GLOBS),$(ZX0_GLOBS_ex)))
$(eval $(call buildnew,compress/zx0,ez80_z80,-mez80_z80,$(ZX0_GLOBS),$(ZX0_GLOBS_ex)))
$(eval $(call buildnew,compress/zx0,kc160,-mkc160,$(ZX0_GLOBS),$(ZX0_GLOBS_ex)))

compress-zx0-clean:
	$(RM) -fr compress/zx0/obj
