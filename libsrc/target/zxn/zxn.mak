# +zxn builds heavily on +zx
ZXN_GLOBS := $(ZX_GLOBS) \
	"target/zxn/esxdos/z80/*.asm" "target/zxn/esxdos/c/sccz80/*.asm" \
	"target/zxn/memory/z80/*.asm" "target/zxn/memory/c/sccz80/*.asm" \
	"target/zxn/globals/z80/*.asm" \
	"target/zxn/sysvar/*.asm" \
	"target/zxn/far/*.asm" \
	"target/zxn/version/z80/*.asm" "target/zxn/version/c/sccz80/*.asm" \
	"target/ts2068/misc/z80/*.asm" "target/ts2068/misc/c/sccz80/*.asm" \
	"target/ts2068/display/z80/*.asm" "target/ts2068/display/c/sccz80/*.asm" \

ZXN_GLOBS_ex := $(ZX_GLOBS_ex) \
	target/zxn/esxdos/z80/*.asm target/zxn/esxdos/c/sccz80/*.asm \
	target/zxn/memory/z80/*.asm target/zxn/memory/c/sccz80/*.asm \
	target/zxn/globals/z80/*.asm \
	target/zxn/sysvar/*.asm \
	target/zxn/far/*.asm \
	target/zxn/version/z80/*.asm target/zxn/version/c/sccz80/*.asm \
	target/ts2068/misc/z80/*.asm target/ts2068/misc/c/sccz80/*.asm \
	target/ts2068/display/z80/*.asm target/ts2068/display/c/sccz80/*.asm \



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
