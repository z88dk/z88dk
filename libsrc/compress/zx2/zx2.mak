ZX2_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/zx2//c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx2//z80/*.asm"
ZX2_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/compress/zx2//c/sccz80/*.asm $(NEWLIB_DIRECTORY)/compress/zx2//z80/*.asm


ZX2_NEWLIB_TARGETS := compress/zx2/obj/newlib-z80-compress-zx2 \
	compress/zx2/obj/newlib-z80n-compress-zx2 \
	compress/zx2/obj/newlib-ixiy-compress-zx2 \
	compress/zx2/obj/newlib-r2ka-compress-zx2 \
	compress/zx2/obj/newlib-gbz80-compress-zx2 \
	compress/zx2/obj/newlib-ez80_z80-compress-zx2 \
	compress/zx2/obj/newlib-z180-compress-zx2 \
	compress/zx2/obj/newlib-r4k-compress-zx2 \
	compress/zx2/obj/newlib-kc160-compress-zx2 

OBJS += $(ZX2_NEWLIB_TARGETS)
CLEAN += compress-zx2-clean

compress-zx2: $(ZX2_NEWLIB_TARGETS)

.PHONY: compress-zx2 compress-zx2-clean

$(eval $(call buildnew,compress/zx2,z80,-mz80,$(ZX2_NEWLIBGLOBS),$(ZX2_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx2,r2ka,-mr2ka,$(ZX2_NEWLIBGLOBS),$(ZX2_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx2,r4k,-mr4k,$(ZX2_NEWLIBGLOBS),$(ZX2_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx2,z80n,-mz80n,$(ZX2_NEWLIBGLOBS),$(ZX2_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx2,ixiy,-mz80 -IXIY,$(ZX2_NEWLIBGLOBS),$(ZX2_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx2,8080,-m8080,$(ZX2_8080_NEWLIBGLOBS),$(ZX2_8080_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx2,gbz80,-mgbz80,$(ZX2_NEWLIBGLOBS),$(ZX2_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx2,z180,-mz180,$(ZX2_NEWLIBGLOBS),$(ZX2_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx2,ez80_z80,-mez80_z80,$(ZX2_NEWLIBGLOBS),$(ZX2_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,compress/zx2,kc160,-mkc160,$(ZX2_NEWLIBGLOBS),$(ZX2_NEWLIBGLOBS_ex)))

compress-zx2-clean:
	$(RM) -fr compress/zx2/obj
