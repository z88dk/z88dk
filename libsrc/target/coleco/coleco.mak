COLECO_GLOBS := \
	"target/coleco/games/*.asm" \
	"target/coleco/stdio/*.asm"

COLECO_GLOBS_ex := \
	target/coleco/games/*.asm \
	target/coleco/stdio/*.asm


COLECO_TARGETS := target/coleco/obj/target-coleco-coleco classic/games/obj/.stamp-coleco classic/gfx/obj/.stamp-coleco


CLEAN += target-coleco-clean

$(eval $(call gfx_stamp_args,coleco,TARGET=coleco))
$(eval $(call gfx_stamp_args,cpm-coleco,TARGET=coleco FLAVOUR=narrow))

target-coleco: $(COLECO_TARGETS)

.PHONY: target-coleco target-coleco-clean

$(eval $(call buildtargetasm,target/coleco,z80,coleco,-mz80,$(COLECO_GLOBS),$(COLECO_GLOBS_ex)))

target-coleco-clean:
	$(RM) -fr target/coleco/obj
