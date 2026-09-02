NABU_GLOBS := \
	"target/nabu/games/*.asm" \
	"target/nabu/hcca/*.asm" \
	"target/nabu/interrupts/*.asm" \
	"target/nabu/psg/*.asm" \
	"target/nabu/stdio/*.asm"

NABU_GLOBS_ex := \
	target/nabu/games/*.asm \
	target/nabu/hcca/*.asm \
	target/nabu/interrupts/*.asm \
	target/nabu/psg/*.asm \
	target/nabu/stdio/*.asm

NABU_CFILES := $(shell find target/nabu -type f -name '*.c')
NABU_OFILES := $(patsubst target/nabu/%,target/nabu/obj/nabu/%,$(NABU_CFILES:.c=.o))

NABU_TARGETS := target/nabu/obj/target-nabu-nabu $(NABU_OFILES) classic/video/tms9918/obj/nabu classic/games/obj/.stamp-nabu classic/gfx/obj/.stamp-nabu

CLEAN += target-nabu-clean

$(eval $(call gfx_stamp_args,nabu,TARGET=nabu))

target-nabu: $(NABU_TARGETS)

.PHONY: target-nabu target-nabu-clean

$(eval $(call buildtms9918,nabu,nabu))

$(eval $(call buildtargetasm,target/nabu,z80,nabu,-mz80,$(NABU_GLOBS),$(NABU_GLOBS_ex)))
$(eval $(call buildtargetc,target/nabu,nabu))

target-nabu-clean:
	$(RM) -fr target/nabu/obj
