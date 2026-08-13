PACMAN_GLOBS := \
	"target/pacman/games/*.asm" \
	"target/pacman/graphics/*.asm" \
	"target/pacman/stdio/*.asm" \
	"target/pacman/time/*.asm"

PACMAN_GLOBS_ex := \
	target/pacman/games/*.asm \
	target/pacman/graphics/*.asm \
	target/pacman/stdio/*.asm \
	target/pacman/time/*.asm


PACMAN_TARGETS := target/pacman/obj/target-pacman-pacman


CLEAN += target-pacman-clean

target-pacman: $(PACMAN_TARGETS)

.PHONY: target-pacman target-pacman-clean

$(eval $(call buildtargetasm,target/pacman,z80,pacman,-mz80,$(PACMAN_GLOBS),$(PACMAN_GLOBS_ex)))

target-pacman-clean:
	$(RM) -fr target/pacman/obj
