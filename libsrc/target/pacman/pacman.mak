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


PACMAN_TARGETS := target/pacman/obj/target-pacman-pacman classic/games/obj/.stamp-pacman classic/gfx/obj/.stamp-pacman

$(eval $(call gfx_stamp_args,pacman,TARGET=pacman FLAVOUR="text6 narrow"))
CLEAN += target-pacman-clean
TOCREATE += $(call check_target,pacman,pacman_clib.lib)
$(eval $(call buildtargetasm,target/pacman,z80,pacman,-mz80,$(PACMAN_GLOBS),$(PACMAN_GLOBS_ex)))

pacman_clib.lib: $(TARGET_CLIB_DEPS) $(PACMAN_TARGETS)
	TARGET=pacman TYPE=z80 $(LIBLINKER) -DFORpacman -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pacman_clib @$(TARGET_DIRECTORY)/pacman/pacman.lst




target-pacman: $(PACMAN_TARGETS)

.PHONY: target-pacman target-pacman-clean


target-pacman-clean:
	$(RM) -fr target/pacman/obj
