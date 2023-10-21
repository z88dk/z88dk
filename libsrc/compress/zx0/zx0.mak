ZX0_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/zx0//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx0//z80/*.asm"
ZX0_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/compress/zx0//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/zx0//z80/*.asm

ZX0_8080_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/zx0//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx0//8080/*.asm"
ZX0_8080_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/compress/zx0//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/zx0//8080/*.asm

ZX0_NEWLIB_TARGETS := compress/zx0/obj/newlib-z80-compress-zx0 \
	compress/zx0/obj/newlib-z80n-compress-zx0 \
	compress/zx0/obj/newlib-ixiy-compress-zx0 \
	compress/zx0/obj/newlib-8080-compress-zx0 \
	compress/zx0/obj/newlib-r2ka-compress-zx0 \
	compress/zx0/obj/newlib-ez80_z80-compress-zx0 \
	compress/zx0/obj/newlib-z180-compress-zx0 \
	compress/zx0/obj/newlib-r4k-compress-zx0 \
	compress/zx0/obj/newlib-kc160-compress-zx0 

OBJS += $(ZX0_NEWLIB_TARGETS)
CLEAN += compress-zx0-clean

compress-zx0: $(ZX0_NEWLIB_TARGETS)

.PHONY: compress-zx0 compress-zx0-clean

$(eval $(call buildnew,compress/zx0,z80,-mz80,$(ZX0_NEWLIBGLOBS),$(ZX0_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx0,r2ka,-mr2ka,$(ZX0_NEWLIBGLOBS),$(ZX0_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx0,r4k,-mr4k,$(ZX0_NEWLIBGLOBS),$(ZX0_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx0,z80n,-mz80n,$(ZX0_NEWLIBGLOBS),$(ZX0_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx0,ixiy,-mz80 -IXIY,$(ZX0_NEWLIBGLOBS),$(ZX0_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx0,8080,-m8080,$(ZX0_8080_NEWLIBGLOBS),$(ZX0_8080_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx0,gbz80,-mgbz80,$(ZX0_8080_NEWLIBGLOBS),$(ZX0_8080_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx0,z180,-mz180,$(ZX0_NEWLIBGLOBS),$(ZX0_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx0,ez80_z80,-mez80_z80,$(ZX0_NEWLIBGLOBS),$(ZX0_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx0,kc160,-mkc160,$(ZX0_NEWLIBGLOBS),$(ZX0_NEWLIBGLOBS_ex)))

compress-zx0-clean:
	$(RM) -fr compress/zx0/obj
