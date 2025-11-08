# +zxn builds heavily on +zx
ZXN_GLOBS := $(ZX_GLOBS) \
	"$(Z88DK_LIBSRC)/target/zxn-libs/memory/z80/*.asm" "$(Z88DK_LIBSRC)/target/zxn-libs/memory/c/sccz80/*.asm" \
        "$(Z88DK_LIBSRC)/target/zxn-libs/globals/z80/*.asm" \
        "$(Z88DK_LIBSRC)/target/zxn-libs/sysvar/*.asm" \
        "$(Z88DK_LIBSRC)/target/zxn-libs/version/z80/*.asm" "$(Z88DK_LIBSRC)/target/zxn-libs/version/c/sccz80/*.asm" \
        "$(Z88DK_LIBSRC)/target/ts2068/misc/z80/*.asm" "$(Z88DK_LIBSRC)/target/ts2068/misc/c/sccz80/*.asm" \
        "$(Z88DK_LIBSRC)/target/ts2068/display/z80/*.asm" "$(Z88DK_LIBSRC)/target/ts2068/display/c/sccz80/*.asm" \
        "$(Z88DK_LIBSRC)/newlib/target/zxn/driver/banking/zxn_banked_call.asm"	

ZXN_GLOBS_ex := $(ZX_GLOBS_ex) \
	$(Z88DK_LIBSRC)/target/zxn-libs/memory/z80/*.asm $(Z88DK_LIBSRC)/target/zxn-libs/memory/c/sccz80/*.asm \
        $(Z88DK_LIBSRC)/target/zxn-libs/globals/z80/*.asm \
        $(Z88DK_LIBSRC)/target/zxn-libs/sysvar/*.asm \
        $(Z88DK_LIBSRC)/target/zxn-libs/version/z80/*.asm $(Z88DK_LIBSRC)/target/zxn-libs/version/c/sccz80/*.asm \
        $(Z88DK_LIBSRC)/target/ts2068/misc/z80/*.asm $(Z88DK_LIBSRC)/target/ts2068/misc/c/sccz80/*.asm \
        $(Z88DK_LIBSRC)/target/ts2068/display/z80/*.asm $(Z88DK_LIBSRC)/target/ts2068/display/c/sccz80/*.asm \
        $(Z88DK_LIBSRC)/newlib/target/zxn/driver/banking/zxn_banked_call.asm	



ZXN_CFILES = target/zx/tape/tape_save.c

ZXN_OFILES = $(addprefix target/zxn/obj/zxn/, $(ZXN_CFILES:.c=.o)) 


ZXN_TARGETS := target/zxn/obj/target-zxn-zxn $(ZXN_OFILES)
		

CLEAN += target-zxn-clean

target-zxn: $(ZXN_TARGETS)

.PHONY: target-zxn target-zxn-clean


$(eval $(call buildtargetasm,target/zxn,z80n,zxn,-mz80n,$(ZXN_GLOBS) $(ZX_MULTICOLOUR_GLOBS),$(ZXN_GLOBS_ex) $(ZX_MULTICOLOUR_GLOBS_ex) $(addprefix target/zxn/obj/zxn/, $(BIFROST2_GEN))))
$(eval $(call buildtargetc,target/zxn,zxn,-clib=classic))
$(eval $(call bifrost_zx0,zxn))

target-zxn-clean:
	$(RM) -fr target/zxn/obj
