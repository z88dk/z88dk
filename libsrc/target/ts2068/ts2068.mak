TS2068_GLOBS := "$(Z88DK_LIBSRC)/target/zx/display/c/sccz80/*.asm" "$(Z88DK_LIBSRC)/target/zx/display/z80/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/misc/c/sccz80/*.asm" "$(Z88DK_LIBSRC)/target/zx/misc/z80/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/diagnostic/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/basic/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/opus/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/specdrum/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/uspeech/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/games/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/input/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/if1/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/zxmmc/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/stdio/*.asm"\
	"$(Z88DK_LIBSRC)/target/zx/classic/graphics/*.asm" \
	"$(Z88DK_LIBSRC)/target/ts2068/psg/*.asm"  \
	"$(Z88DK_LIBSRC)/target/ts2068/stdio/*.asm"  \
	"$(Z88DK_LIBSRC)/target/ts2068/stdio/ansi/*.asm"  \

TS2068_GLOBS_ex := $(Z88DK_LIBSRC)/target/zx/display/c/sccz80/*.asm $(Z88DK_LIBSRC)/target/zx/display/z80/*.asm \
	$(Z88DK_LIBSRC)/target/zx/misc/c/sccz80/*.asm $(Z88DK_LIBSRC)/target/zx/misc/z80/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/diagnostic/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/basic/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/opus/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/specdrum/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/uspeech/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/games/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/input/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/if1/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/zxmmc/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/stdio/*.asm\
	$(Z88DK_LIBSRC)/target/zx/classic/graphics/*.asm \
	$(Z88DK_LIBSRC)/target/ts2068/psg/*.asm  \
	$(Z88DK_LIBSRC)/target/ts2068/stdio/*.asm  \
	$(Z88DK_LIBSRC)/target/ts2068/stdio/ansi/*.asm  \


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
