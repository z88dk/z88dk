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
	"target/zxn/sprites/c/sccz80/*.asm" \
	"target/zxn/classic/stdio/*.asm" \
	"target/zxn/classic/graphics/*.asm"

ZXN_GLOBS_ex := $(ZX_GLOBS_ex) \
	target/zxn/esxdos/z80/*.asm target/zxn/esxdos/c/sccz80/*.asm \
	target/zxn/memory/z80/*.asm target/zxn/memory/c/sccz80/*.asm \
	target/zxn/globals/z80/*.asm \
	target/zxn/sysvar/*.asm \
	target/zxn/far/*.asm \
	target/zxn/version/z80/*.asm target/zxn/version/c/sccz80/*.asm \
	target/ts2068/misc/z80/*.asm target/ts2068/misc/c/sccz80/*.asm \
	target/ts2068/display/z80/*.asm target/ts2068/display/c/sccz80/*.asm \
	target/zxn/sprites/c/sccz80/*.asm  \
	target/zxn/classic/stdio/*.asm \
	target/zxn/classic/graphics/*.asm




ZXN_CFILES = target/zx/tape/tape_save.c

ZXN_OFILES = $(addprefix target/zxn/obj/zxn/, $(ZXN_CFILES:.c=.o)) 


ZXN_TARGETS := target/zxn/obj/target-zxn-zxn $(ZXN_OFILES)
		

CLEAN += target-zxn-clean

target-zxn: $(ZXN_TARGETS)

.PHONY: target-zxn target-zxn-clean


$(eval $(call buildtargetasm,target/zxn,z80n,zxn,-mz80n,$(ZXN_GLOBS) $(ZX_MULTICOLOUR_GLOBS),$(ZXN_GLOBS_ex) $(ZX_MULTICOLOUR_GLOBS_ex) $(addprefix target/zxn/obj/zxn/, $(BIFROST2_GEN))))
$(eval $(call buildtargetc,target/zxn,zxn,-clib=classic))
$(eval $(call bifrost_zx0,zxn))

# zx and zxn share the multicolour engine sources under target/zx, and z80asm
# expands a .asm.m4 into the .asm beside the source rather than into the
# per-target obj dir. Under -j both assemblies write and read that one file.
# Order the zxn side after the zx side, for the bifrost_zx0 rules and for the
# buildtargetasm stamps that assemble $(ZX_MULTICOLOUR_GLOBS).
#
# Chaining zxn_clib.lib to zx_clib.lib would not work: make may build
# $(ZXN_TARGETS) and zx_clib.lib concurrently, one shared source in each.
target/zxn/obj/zxn/bifrost2_engine_48.bin.zx0: target/zx/obj/zx/bifrost2_engine_p3.bin.zx0
target/zxn/obj/target-zxn-zxn: target/zx/obj/target-zx-zx

target-zxn-clean:
	$(RM) -fr target/zxn/obj
