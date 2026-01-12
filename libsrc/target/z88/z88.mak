

Z88_GLOBS := \
	"target/zx/display/c/sccz80/*.asm" "target/zx/display/z80/*.asm" \
	"target/z88/zx/c/smallc/*.asm" "target/z88/zx/z80/*.asm" \
	"target/z88/far/*.asm" \
	"target/z88/fcntl/*.asm" \
	"target/z88/games/*.asm" \
	"target/z88/graphics/*.asm" \
	"target/z88/input/*.asm" \
	"target/z88/net/*.asm" \
	"target/z88/stdio/*.asm" \
	"target/z88/stdio/ansi/*.asm" \
	"target/z88/stdlib/*.asm" \
	"target/z88/z88/*.asm" \
	target/zx/classic/graphics/pixladdr_MODE0.asm

Z88_GLOBS_ex := \
	target/zx/display/c/sccz80/*.asm target/zx/display/z80/*.asm \
	target/z88/zx/c/smallc/*.asm target/z88/zx/z80/*.asm \
	target/z88/far/*.asm \
	target/z88/fcntl/*.asm \
	target/z88/games/*.asm \
	target/z88/graphics/*.asm \
	target/z88/input/*.asm \
	target/z88/net/*.asm \
	target/z88/stdio/*.asm \
	target/z88/stdio/ansi/*.asm \
	target/z88/stdlib/*.asm \
	target/z88/z88/*.asm \
	target/zx/classic/graphics/pixladdr_MODE0.asm



Z88_CFILES = $(wildcard target/z88/fcntl/*.c) $(wildcard target/z88/net/*.c) $(wildcard target/z88/rs232/*.c) $(wildcard target/z88/time/*.c) $(wildcard target/z88/z88/*.c)

Z88_OFILES = $(addprefix target/z88/obj/z88/, $(Z88_CFILES:.c=.o)) 



Z88_TARGETS := target/z88/obj/target-z88-z88  $(Z88_OFILES) 
		

CLEAN += target-z88-clean

target-z88: $(Z88_TARGETS)

.PHONY: target-z88 target-z88-clean


$(eval $(call buildtargetasm,target/z88,z80,z88,-mz80,$(Z88_GLOBS),$(Z88_GLOBS_ex)))
$(eval $(call buildtargetc,target/z88,z88))


target-z88-clean:
	$(RM) -fr target/z88/obj
