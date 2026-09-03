Z1013_GLOBS := \
	"target/z1013/games/*.asm" \
	"target/z1013/graphics/*.asm" \
	"target/z1013/stdio/*.asm" \
	"target/z1013/stdio/ansi/*.asm" 

Z1013_GLOBS_ex := \
	target/z1013/games/*.asm \
	target/z1013/graphics/*.asm \
	target/z1013/stdio/*.asm \
	target/z1013/stdio/ansi/*.asm 


Z1013_TARGETS := target/z1013/obj/target-z1013-z1013 classic/games/obj/.stamp-z1013 classic/gfx/obj/.stamp-z1013
		

CLEAN += target-z1013-clean
TOCREATE += $(call check_target,z1013,z1013_clib.lib)
$(eval $(call gfx_stamp_args,z1013,TARGET=z1013 FLAVOUR="gencon narrow"))
$(eval $(call buildtargetasm,target/z1013,z80,z1013,-mz80,$(Z1013_GLOBS),$(Z1013_GLOBS_ex)))

z1013_clib.lib: $(TARGET_CLIB_DEPS) $(Z1013_TARGETS)
	@echo ''
	@echo '--- Building Robotron Z1013 Library ---'
	@echo ''
	$(MAKE) -C classic/video/krt TARGET=z1013
	TARGET=z1013 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz1013 -x$(OUTPUT_DIRECTORY)/z1013_clib @$(TARGET_DIRECTORY)/z1013/z1013.lst



target-z1013: $(Z1013_TARGETS)

.PHONY: target-z1013 target-z1013-clean



target-z1013-clean:
	$(RM) -fr target/z1013/obj
