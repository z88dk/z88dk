ABC80_GLOBS := \
	"target/abc80/abc80/*.asm" \
	"target/abc80/graphics/*.asm" \
	"target/abc80/stdio/*.asm" \
	"target/abc80/stdio/ansi/*.asm" \
	"target/abc80/time/*.asm" 

ABC80_GLOBS_ex := \
	target/abc80/abc80/*.asm \
	target/abc80/graphics/*.asm \
	target/abc80/stdio/*.asm \
	target/abc80/stdio/ansi/*.asm \
	target/abc80/time/*.asm 


ABC80_TARGETS := target/abc80/obj/target-abc80-abc80 classic/games/obj/.stamp-abc80 classic/gfx/obj/.stamp-abc80
		

CLEAN += target-abc80-clean
TOCREATE += $(call check_target,abc80,abc80_clib.lib)
$(eval $(call gfx_stamp_args,abc80,TARGET=abc80))
$(eval $(call buildtargetasm,target/abc80,z80,abc80,-mz80,$(ABC80_GLOBS),$(ABC80_GLOBS_ex)))

abc80_clib.lib: $(TARGET_CLIB_DEPS) $(ABC80_TARGETS)
	@echo ''
	@echo '--- Building ABC80 Library ---'
	@echo ''
	TARGET=abc80 TYPE=z80 $(LIBLINKER)  -DFORabc80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/abc80_clib @$(TARGET_DIRECTORY)/abc80/abc80.lst



target-abc80: $(ABC80_TARGETS)

.PHONY: target-abc80 target-abc80-clean



target-abc80-clean:
	$(RM) -fr target/abc80/obj
