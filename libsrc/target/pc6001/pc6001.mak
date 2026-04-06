PC6001_GLOBS := \
	"target/pc6001/games/*.asm" \
	"target/pc6001/graphics/*.asm" \
	"target/pc6001/psg/*.asm" \
	"target/pc6001/stdio/*.asm" \
	"target/pc6001/stdio/ansi/*.asm" 

PC6001_GLOBS_ex := \
	target/pc6001/games/*.asm \
	target/pc6001/graphics/*.asm \
	target/pc6001/psg/*.asm \
	target/pc6001/stdio/*.asm \
	target/pc6001/stdio/ansi/*.asm 


PC6001_TARGETS := target/pc6001/obj/target-pc6001-pc6001
		

CLEAN += target-pc6001-clean

target-pc6001: $(PC6001_TARGETS)

.PHONY: target-pc6001 target-pc6001-clean


$(eval $(call buildtargetasm,target/pc6001,z80,pc6001,-mz80,$(PC6001_GLOBS),$(PC6001_GLOBS_ex)))

target-pc6001-clean:
	$(RM) -fr target/pc6001/obj
