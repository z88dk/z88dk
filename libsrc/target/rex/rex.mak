REX_GLOBS := \
	"target/rex/*.asm" \
	"target/rex/farcall/*.asm" \
	"target/rex/graphics/*.asm"

REX_GLOBS_ex := \
	target/rex/*.asm \
	target/rex/farcall/*.asm \
	target/rex/graphics/*.asm

REX_CFILES = $(wildcard target/rex/graphics/*.c)

REX_OFILES = $(addprefix target/rex/obj/rex/, $(REX_CFILES:.c=.o))


REX_TARGETS := target/rex/obj/target-rex-rex \
	$(REX_OFILES)


CLEAN += target-rex-clean

target-rex: $(REX_TARGETS)

.PHONY: target-rex target-rex-clean

$(eval $(call buildtargetasm,target/rex,z80,rex,-mz80,$(REX_GLOBS),$(REX_GLOBS_ex)))
$(eval $(call buildtargetc,target/rex,rex,$(CFLAGS)))

target-rex-clean:
	$(RM) -fr target/rex/obj
