GL6000_GL6000OBS := \
	"target/gl6000/games/*.asm" \
	"target/gl6000/graphics/*.asm" \
	"target/gl6000/input/*.asm" \
	"target/gl6000/stdio/*.asm" \
	"target/gl6000/video/*.asm" 

GL6000_GL6000OBS_ex := \
	target/gl6000/games/*.asm \
	target/gl6000/graphics/*.asm \
	target/gl6000/input/*.asm \
	target/gl6000/stdio/*.asm \
	target/gl6000/video/*.asm 


GL6000_TARGETS := target/gl6000/obj/target-gl6000-gl6000
		

CLEAN += target-gl6000-clean

target-gl6000: $(GL6000_TARGETS)

.PHONY: target-gl6000 target-gl6000-clean


$(eval $(call buildtargetasm,target/gl6000,z80,gl6000,-mz80,$(GL6000_GL6000OBS),$(GL6000_GL6000OBS_ex)))

target-gl6000-clean:
	$(RM) -fr target/gl6000/obj
