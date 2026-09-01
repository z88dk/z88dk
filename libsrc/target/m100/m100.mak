M100_GLOBS := \
	"target/m100/graphics/*.asm" \
	"target/m100/stdio/*.asm"

M100_GLOBS_ex := \
	target/m100/graphics/*.asm \
	target/m100/stdio/*.asm


M100_TARGETS := target/m100/obj/target-m100-m100 classic/games/obj/.stamp-m100 classic/gfx/obj/.stamp-m100


CLEAN += target-m100-clean

$(eval $(call gfx_stamp_args,m100,TARGET=m100 FLAVOUR=narrow))

target-m100: $(M100_TARGETS)

.PHONY: target-m100 target-m100-clean

$(eval $(call buildtargetasm,target/m100,8085,m100,-m8085 -DSTANDARDESCAPECHARS,$(M100_GLOBS),$(M100_GLOBS_ex)))

target-m100-clean:
	$(RM) -fr target/m100/obj
