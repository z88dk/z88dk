ZX1_GLOBS := "compress/zx1//c/sccz80/*.asm" "compress/zx1//z80/*.asm"
ZX1_GLOBS_ex := compress/zx1//c/sccz80/*.asm compress/zx1//z80/*.asm

ZX1_8080_GLOBS := "compress/zx1//c/sccz80/*.asm" "compress/zx1//8080/*.asm"
ZX1_8080_GLOBS_ex := compress/zx1//c/sccz80/*.asm compress/zx1//8080/*.asm

ZX1_TARGETS := compress/zx1/obj/newlib-z80-compress-zx1 \
	compress/zx1/obj/newlib-z80n-compress-zx1 \
	compress/zx1/obj/newlib-ixiy-compress-zx1 \
	compress/zx1/obj/newlib-8080-compress-zx1 \
	compress/zx1/obj/newlib-8085-compress-zx1 \
	compress/zx1/obj/newlib-r2ka-compress-zx1 \
	compress/zx1/obj/newlib-ez80_z80-compress-zx1 \
	compress/zx1/obj/newlib-z180-compress-zx1 \
	compress/zx1/obj/newlib-r4k-compress-zx1 \
	compress/zx1/obj/newlib-kc160-compress-zx1 


OBJS += $(ZX1_TARGETS)
CLEAN += compress-zx1-clean

compress-zx1: $(ZX1_TARGETS)

.PHONY: compress-zx1 compress-zx1-clean

$(eval $(call buildnew,compress/zx1,z80,-mz80,$(ZX1_GLOBS),$(ZX1_GLOBS_ex)))
$(eval $(call buildnew,compress/zx1,r2ka,-mr2ka,$(ZX1_GLOBS),$(ZX1_GLOBS_ex)))
$(eval $(call buildnew,compress/zx1,r4k,-mr4k,$(ZX1_GLOBS),$(ZX1_GLOBS_ex)))
$(eval $(call buildnew,compress/zx1,z80n,-mz80n,$(ZX1_GLOBS),$(ZX1_GLOBS_ex)))
$(eval $(call buildnew,compress/zx1,ixiy,-mz80 -IXIY,$(ZX1_GLOBS),$(ZX1_GLOBS_ex)))
$(eval $(call buildnew,compress/zx1,8080,-m8080,$(ZX1_8080_GLOBS),$(ZX1_8080_GLOBS_ex)))
$(eval $(call buildnew,compress/zx1,8085,-m8085,$(ZX1_8080_GLOBS),$(ZX1_8080_GLOBS_ex)))
$(eval $(call buildnew,compress/zx1,gbz80,-mgbz80,$(ZX1_GLOBS),$(ZX1_GLOBS_ex)))
$(eval $(call buildnew,compress/zx1,z180,-mz180,$(ZX1_GLOBS),$(ZX1_GLOBS_ex)))
$(eval $(call buildnew,compress/zx1,ez80_z80,-mez80_z80,$(ZX1_GLOBS),$(ZX1_GLOBS_ex)))
$(eval $(call buildnew,compress/zx1,kc160,-mkc160,$(ZX1_GLOBS),$(ZX1_GLOBS_ex)))

compress-zx1-clean:
	$(RM) -fr compress/zx1/obj
