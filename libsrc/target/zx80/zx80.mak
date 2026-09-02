ZX80_GLOBS := \
	"target/zx80/graphics/*.asm" \
	"target/zx80/stdio/*.asm"

ZX80_GLOBS_ex := \
	target/zx80/graphics/*.asm \
	target/zx80/stdio/*.asm

ZX80_TARGETS := \
	target/zx80/obj/target-zx80-zx80 \
	target/zx80/obj/zx80/stdlib/sleep.o \
	target/zx81/obj/target-zx81-zx80 \
	classic/games/obj/.stamp-zx80 \
	classic/gfx/obj/.stamp-zx80

$(eval $(call gfx_stamp_args,zx80,TARGET=zx80))

CLEAN += target-zx80-clean

target-zx80: $(ZX80_TARGETS)

.PHONY: target-zx80 target-zx80-clean

$(eval $(call buildtargetasm,target/zx80,z80,zx80,-mz80,$(ZX80_GLOBS),$(ZX80_GLOBS_ex)))
$(eval $(call buildtargetc,target/zx80,zx80))

# ZX80 uses the shared ZX81 sources with the plain Z80 ABI, not IX/IY.
$(eval $(call buildtargetasm,target/zx81,z80,zx80,-mz80,$(ZX81_BASE_GLOBS),$(ZX81_BASE_GLOBS_ex)))

target-zx80-clean:
	$(RM) -fr target/zx80/obj
