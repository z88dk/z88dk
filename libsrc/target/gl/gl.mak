GL_GLOBS := \
	"target/gl/games/*.asm" \
	"target/gl/stdio/*.asm" \
	"target/gl/video/*.asm" 

GL_GLOBS_ex := \
	target/gl/games/*.asm \
	target/gl/stdio/*.asm \
	target/gl/video/*.asm 


GL_TARGETS := target/gl/obj/target-gl-gl classic/games/obj/.stamp-gl classic/gfx/obj/.stamp-gl
		

CLEAN += target-gl-clean

$(eval $(call gfx_stamp_args,gl,TARGET=gl))

target-gl: $(GL_TARGETS)

.PHONY: target-gl target-gl-clean


$(eval $(call buildtargetasm,target/gl,z80,gl,-mz80,$(GL_GLOBS),$(GL_GLOBS_ex)))

target-gl-clean:
	$(RM) -fr target/gl/obj
