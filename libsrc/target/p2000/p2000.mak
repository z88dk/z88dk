P2000_GLOBS := \
	"target/p2000/games/*.asm" \
	"target/p2000/graphics/*.asm" \
	"target/p2000/input/*.asm" \
	"target/p2000/stdio/*.asm" \
	"target/p2000/stdio/ansi/*.asm" \
	"target/p2000/time/*.asm"

P2000_GLOBS_ex := \
	target/p2000/games/*.asm \
	target/p2000/graphics/*.asm \
	target/p2000/input/*.asm \
	target/p2000/stdio/*.asm \
	target/p2000/stdio/ansi/*.asm \
	target/p2000/time/*.asm


P2000_TARGETS := target/p2000/obj/target-p2000-p2000 classic/games/obj/.stamp-p2000 classic/gfx/obj/.stamp-p2000

$(eval $(call gfx_stamp_args,p2000,TARGET=p2000 FLAVOUR="text6 narrow"))


CLEAN += target-p2000-clean

target-p2000: $(P2000_TARGETS)

.PHONY: target-p2000 target-p2000-clean

$(eval $(call buildtargetasm,target/p2000,z80,p2000,-mz80 -DSTANDARDESCAPECHARS,$(P2000_GLOBS),$(P2000_GLOBS_ex)))

target-p2000-clean:
	$(RM) -fr target/p2000/obj
