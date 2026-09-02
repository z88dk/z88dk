ABC800_GLOBS := \
	"target/abc80/graphics/*.asm" \
	"target/abc800/abc800/*.asm" \
	"target/abc800/stdio/*.asm" 

ABC800_GLOBS_ex := \
	target/abc80/graphics/*.asm \
	target/abc800/abc800/*.asm \
	target/abc800/stdio/*.asm 


ABC800_TARGETS := target/abc800/obj/target-abc800-abc800 classic/games/obj/.stamp-abc800 classic/gfx/obj/.stamp-abc800
		

CLEAN += target-abc800-clean
abc800_clib.lib: $(TARGET_CLIB_DEPS) $(ABC800_TARGETS)
	@echo ''
	@echo '--- Building ABC800 Library ---'
	@echo ''
	$(RM) target/abc80/graphics/*.o
	TARGET=abc800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/abc800_clib @$(TARGET_DIRECTORY)/abc800/abc800.lst

TOCREATE += $(call check_target,abc800,abc800_clib.lib)

$(eval $(call gfx_stamp_args,abc800,TARGET=abc800))

target-abc800: $(ABC800_TARGETS)

.PHONY: target-abc800 target-abc800-clean


$(eval $(call buildtargetasm,target/abc800,z80,abc800,-mz80,$(ABC800_GLOBS),$(ABC800_GLOBS_ex)))

target-abc800-clean:
	$(RM) -fr target/abc800/obj
