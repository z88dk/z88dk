X1_GLOBS := \
	"target/x1/graphics/*.asm" \
	"target/x1/input/*.asm" \
	"target/x1/psg/*.asm" \
	"target/x1/stdio/*.asm" \
	"target/x1/stdio/ansi/*.asm" \
	"target/x1/x1/*.asm"

X1_GLOBS_ex := \
	target/x1/graphics/*.asm \
	target/x1/input/*.asm \
	target/x1/psg/*.asm \
	target/x1/stdio/*.asm \
	target/x1/stdio/ansi/*.asm \
	target/x1/x1/*.asm

X1_CFILES := $(wildcard target/x1/x1/*.c) $(wildcard target/x1/time/*.c)
X1_OFILES := $(addprefix target/x1/obj/x1/,$(X1_CFILES:.c=.o))

X1_TARGETS := target/x1/obj/target-x1-x1 $(X1_OFILES) classic/games/obj/.stamp-x1 classic/gfx/obj/.stamp-x1
X1_CPM_TARGETS := target/x1/obj/target-x1-x1 $(X1_OFILES) classic/gfx/obj/.stamp-cpm-x1

CLEAN += target-x1-clean

target-x1: $(X1_TARGETS) $(X1_CPM_TARGETS)

.PHONY: target-x1 target-x1-clean

$(eval $(call buildtargetasm,target/x1,z80,x1,-mz80,$(X1_GLOBS),$(X1_GLOBS_ex)))
$(eval $(call buildtargetc,target/x1,x1))

target-x1-clean:
	$(RM) -fr target/x1/obj
