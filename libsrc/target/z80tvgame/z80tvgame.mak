Z80TVGAME_GLOBS := \
	"target/z80tvgame/games/*.asm" \
	"target/z80tvgame/graphics/*.asm" \
	"target/z80tvgame/stdio/*.asm" 

Z80TVGAME_GLOBS_ex := \
	target/z80tvgame/games/*.asm \
	target/z80tvgame/graphics/*.asm \
	target/z80tvgame/stdio/*.asm 


Z80TVGAME_TARGETS := target/z80tvgame/obj/target-z80tvgame-z80tvgame
		

CLEAN += target-z80tvgame-clean

target-z80tvgame: $(Z80TVGAME_TARGETS)

.PHONY: target-z80tvgame target-z80tvgame-clean


$(eval $(call buildtargetasm,target/z80tvgame,z80,z80tvgame,-mz80,$(Z80TVGAME_GLOBS),$(Z80TVGAME_GLOBS_ex)))

target-z80tvgame-clean:
	$(RM) -fr target/z80tvgame/obj
