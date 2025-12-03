TS2068_GLOBS := "target/zx/display/c/sccz80/*.asm" "target/zx/display/z80/*.asm" \
	"target/zx/misc/c/sccz80/*.asm" "target/zx/misc/z80/*.asm" \
	"target/zx/classic/diagnostic/*.asm" \
	"target/zx/classic/basic/*.asm" \
	"target/zx/classic/opus/*.asm" \
	"target/zx/classic/uspeech/*.asm" \
	"target/zx/classic/games/*.asm" \
	"target/zx/classic/input/*.asm" \
	"target/zx/classic/if1/*.asm" \
	"target/zx/classic/misc/*.asm" \
	"target/zx/classic/zxmmc/*.asm" \
	"target/zx/classic/stdio/*.asm"\
	"target/zx/classic/stdio/ansi/f_ansi_bel.asm" \
	"target/zx/classic/graphics/*.asm" \
	"target/ts2068/psg/*.asm"  \
	"target/ts2068/stdio/*.asm"  \
	"target/ts2068/stdio/ansi/*.asm"  \
	"target/ts2068/*.asm"  \
	"target/shared/clock.asm"

TS2068_GLOBS_ex := target/zx/display/c/sccz80/*.asm target/zx/display/z80/*.asm \
	target/zx/misc/c/sccz80/*.asm target/zx/misc/z80/*.asm \
	target/zx/classic/diagnostic/*.asm \
	target/zx/classic/basic/*.asm \
	target/zx/classic/opus/*.asm \
	target/zx/classic/uspeech/*.asm \
	target/zx/classic/games/*.asm \
	target/zx/classic/input/*.asm \
	target/zx/classic/if1/*.asm \
	target/zx/classic/misc/*.asm \
	target/zx/classic/zxmmc/*.asm \
	target/zx/classic/stdio/*.asm\
	target/zx/classic/stdio/ansi/f_ansi_bel.asm \
	target/zx/classic/graphics/*.asm \
	target/ts2068/psg/*.asm  \
	target/ts2068/stdio/*.asm  \
	target/ts2068/stdio/ansi/*.asm  \
	target/ts2068/*.asm  \
	target/shared/clock.asm


TS2068_CFILES = target/zx/tape/tape_save.c

TS2068_OFILES = $(addprefix target/ts2068/obj/ts2068/, $(TS2068_CFILES:.c=.o)) 


BIFROST2_GEN = bifrost2_engine_48.bin.zx0 bifrost2_engine_p3.bin.zx0


TS2068_TARGETS := target/ts2068/obj/target-ts2068-ts2068 \
	$(TS2068_OFILES)
		

CLEAN += target-ts2068-clean

target-ts2068: $(TS2068_TARGETS)

.PHONY: target-ts2068 target-ts2068-clean

$(eval $(call buildtargetasm,target/ts2068,z80,ts2068,-mz80,$(TS2068_GLOBS),$(TS2068_GLOBS_ex)))
$(eval $(call buildtargetc,target/ts2068,ts2068))

target-ts2068-clean:
	$(RM) -fr target/ts2068/obj
