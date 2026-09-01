PCW_GLOBS := \
	"target/pcw/far/*.asm" \
	"target/pcw/graphics/*.asm" \
	"target/pcw/psg/*.asm"

PCW_GLOBS_ex := \
	target/pcw/far/*.asm \
	target/pcw/graphics/*.asm \
	target/pcw/psg/*.asm


PCW_TARGETS := target/pcw/obj/target-pcw-pcw classic/games/obj/.stamp-cpm-pcw classic/gfx/obj/.stamp-cpm-pcw


CLEAN += target-pcw-clean

target-pcw: $(PCW_TARGETS)

.PHONY: target-pcw target-pcw-clean

$(eval $(call buildtargetasm,target/pcw,z80,pcw,-mz80,$(PCW_GLOBS),$(PCW_GLOBS_ex)))

target-pcw-clean:
	$(RM) -fr target/pcw/obj
