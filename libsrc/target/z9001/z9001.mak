Z9001_GLOBS := \
	"target/z9001/games/*.asm" \
	"target/z9001/graphics/*.asm" \
	"target/z9001/stdio/*.asm" \
	"target/z9001/stdio/ansi/*.asm" 

Z9001_GLOBS_ex := \
	target/z9001/games/*.asm \
	target/z9001/graphics/*.asm \
	target/z9001/stdio/*.asm \
	target/z9001/stdio/ansi/*.asm 


Z9001_TARGETS := target/z9001/obj/target-z9001-z9001 classic/games/obj/.stamp-z9001 classic/gfx/obj/.stamp-z9001
		

CLEAN += target-z9001-clean
TOCREATE += $(call check_target,z9001,z9001_clib.lib)
$(eval $(call gfx_stamp_args,z9001,TARGET=z9001 FLAVOUR="gencon wide"))
$(eval $(call buildtargetasm,target/z9001,z80,z9001,-mz80,$(Z9001_GLOBS),$(Z9001_GLOBS_ex)))

z9001_clib.lib: $(TARGET_CLIB_DEPS) $(Z9001_TARGETS)
	@echo ''
	@echo '--- Building Robotron KC85/1, KC/87, Z9001 Library ---'
	@echo ''
	$(MAKE) -C classic/video/krt TARGET=z9001
	TARGET=z9001 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz9001 -x$(OUTPUT_DIRECTORY)/z9001_clib @$(TARGET_DIRECTORY)/z9001/z9001.lst



target-z9001: $(Z9001_TARGETS)

.PHONY: target-z9001 target-z9001-clean



target-z9001-clean:
	$(RM) -fr target/z9001/obj
