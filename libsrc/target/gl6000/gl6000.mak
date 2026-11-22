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


GL6000_TARGETS := target/gl6000/obj/target-gl6000-gl6000 classic/games/obj/.stamp-gl6000 classic/gfx/obj/.stamp-gl6000
		

CLEAN += target-gl6000-clean
TOCREATE += $(call check_target,gl6000,gl6000_clib.lib)
$(eval $(call gfx_stamp_args,gl6000,TARGET=gl SUBTYPE=gl6000 FLAVOUR=narrow))
$(eval $(call buildtargetasm,target/gl6000,z80,gl6000,-mz80,$(GL6000_GL6000OBS),$(GL6000_GL6000OBS_ex)))

gl6000_clib.lib: $(TARGET_CLIB_DEPS) gl_clib.lib $(GL6000_TARGETS)
	@echo ''
	@echo '--- Building Genius Leader 6000 Library ---'
	@echo ''
	TARGET=gl6000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORgl6000 -x$(OUTPUT_DIRECTORY)/gl6000_clib @$(TARGET_DIRECTORY)/gl6000/gl6000.lst




target-gl6000: $(GL6000_TARGETS)

.PHONY: target-gl6000 target-gl6000-clean



target-gl6000-clean:
	$(RM) -fr target/gl6000/obj
