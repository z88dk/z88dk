PASOPIA7_GLOBS := \
	"target/pasopia7/games/*.asm" \
	"target/pasopia7/stdio/*.asm"

PASOPIA7_GLOBS_ex := \
	target/pasopia7/games/*.asm \
	target/pasopia7/stdio/*.asm


PASOPIA7_TARGETS := target/pasopia7/obj/target-pasopia7-pasopia7 classic/games/obj/.stamp-pasopia7 classic/gfx/obj/.stamp-pasopia7


CLEAN += target-pasopia7-clean

target-pasopia7: $(PASOPIA7_TARGETS)

.PHONY: target-pasopia7 target-pasopia7-clean

$(eval $(call buildtargetasm,target/pasopia7,z80,pasopia7,-mz80,$(PASOPIA7_GLOBS),$(PASOPIA7_GLOBS_ex)))

target-pasopia7-clean:
	$(RM) -fr target/pasopia7/obj
