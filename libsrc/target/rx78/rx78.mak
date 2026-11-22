RX78_GLOBS := \
	"target/rx78/*.asm" \
	"target/rx78/games/*.asm" \
	"target/rx78/graphics/*.asm" \
	"target/rx78/input/*.asm" \
	"target/rx78/stdio/*.asm" 

RX78_GLOBS_ex := \
	target/rx78/*.asm \
	target/rx78/games/*.asm \
	target/rx78/graphics/*.asm \
	target/rx78/input/*.asm \
	target/rx78/stdio/*.asm 


RX78_TARGETS := target/rx78/obj/target-rx78-rx78 classic/games/obj/.stamp-rx78 classic/gfx/obj/.stamp-rx78
		

CLEAN += target-rx78-clean
TOCREATE += $(call check_target,rx78,rx78_clib.lib)
$(eval $(call gfx_stamp_args,rx78,TARGET=rx78))
$(eval $(call buildtargetasm,target/rx78,z80,rx78,-mz80,$(RX78_GLOBS),$(RX78_GLOBS_ex)))

rx78_clib.lib: $(TARGET_CLIB_DEPS) $(RX78_TARGETS)
	@echo ''
	@echo '--- Building Bandai RX78 Library ---'
	@echo ''
	TARGET=rx78 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORrx78 -x$(OUTPUT_DIRECTORY)/rx78_clib @$(TARGET_DIRECTORY)/rx78/rx78.lst



target-rx78: $(RX78_TARGETS)

.PHONY: target-rx78 target-rx78-clean



target-rx78-clean:
	$(RM) -fr target/rx78/obj
