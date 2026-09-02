Z80TVGAME_GLOBS := \
	"target/z80tvgame/games/*.asm" \
	"target/z80tvgame/graphics/*.asm" \
	"target/z80tvgame/stdio/*.asm" 

Z80TVGAME_GLOBS_ex := \
	target/z80tvgame/games/*.asm \
	target/z80tvgame/graphics/*.asm \
	target/z80tvgame/stdio/*.asm 


Z80TVGAME_TARGETS := target/z80tvgame/obj/target-z80tvgame-z80tvgame classic/games/obj/.stamp-z80tvgame classic/gfx/obj/.stamp-z80tvgame
		

CLEAN += target-z80tvgame-clean
z80tvgame_clib.lib: $(TARGET_CLIB_DEPS) $(Z80TVGAME_TARGETS)
	@echo ''
	@echo '--- Building Z80 TV Game Library ---'
	@echo ''
	TARGET=z80tvgame TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz80tvgame -x$(OUTPUT_DIRECTORY)/z80tvgame_clib @$(TARGET_DIRECTORY)/z80tvgame/z80tvgame.lst


TOCREATE += $(call check_target,z80tvgame,z80tvgame_clib.lib)

$(eval $(call gfx_stamp_args,z80tvgame,TARGET=z80tvgame))

target-z80tvgame: $(Z80TVGAME_TARGETS)

.PHONY: target-z80tvgame target-z80tvgame-clean


$(eval $(call buildtargetasm,target/z80tvgame,z80,z80tvgame,-mz80,$(Z80TVGAME_GLOBS),$(Z80TVGAME_GLOBS_ex)))

target-z80tvgame-clean:
	$(RM) -fr target/z80tvgame/obj
