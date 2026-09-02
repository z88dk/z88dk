REX_GLOBS := \
	"target/rex/*.asm" \
	"target/rex/farcall/*.asm" \
	"target/rex/graphics/*.asm"

REX_GLOBS_ex := \
	target/rex/*.asm \
	target/rex/farcall/*.asm \
	target/rex/graphics/*.asm

REX_CFILES = $(wildcard target/rex/graphics/*.c)

REX_OFILES = $(patsubst target/rex/%,target/rex/obj/rex/%,$(REX_CFILES:.c=.o))


REX_TARGETS := target/rex/obj/target-rex-rex \
	$(REX_OFILES) \
	classic/gfx/obj/.stamp-rex


CLEAN += target-rex-clean
TOCREATE += $(call check_target,rex,rex_clib.lib)

rex_clib.lib: $(TARGET_CLIB_DEPS) $(REX_TARGETS)
	TARGET=rex TYPE=z80 $(LIBLINKER) -DFORrex -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/rex_clib.lib @$(TARGET_DIRECTORY)/rex/rex6000.lst

$(eval $(call gfx_stamp_args,rex,TARGET=rex))

target-rex: $(REX_TARGETS)

.PHONY: target-rex target-rex-clean

$(eval $(call buildtargetasm,target/rex,z80,rex,-mz80,$(REX_GLOBS),$(REX_GLOBS_ex)))
$(eval $(call buildtargetc,target/rex,rex,$(CFLAGS)))

target-rex-clean:
	$(RM) -fr target/rex/obj
