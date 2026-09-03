PRIMO_GLOBS := \
	"target/primo/games/*.asm" \
	"target/primo/graphics/*.asm" \
	"target/primo/input/*.asm" \
	"target/primo/stdio/*.asm" 

PRIMO_GLOBS_ex := \
	target/primo/games/*.asm \
	target/primo/graphics/*.asm \
	target/primo/input/*.asm \
	target/primo/stdio/*.asm 


PRIMO_TARGETS := target/primo/obj/target-primo-primo classic/games/obj/.stamp-primo classic/gfx/obj/.stamp-primo
		

CLEAN += target-primo-clean
TOCREATE += $(call check_target,primo,primo_clib.lib)
$(eval $(call gfx_stamp_args,primo,TARGET=primo))
$(eval $(call buildtargetasm,target/primo,z80,primo,-mz80 -IXIY,$(PRIMO_GLOBS),$(PRIMO_GLOBS_ex)))

primo_clib.lib: $(TARGET_CLIB_DEPS) $(PRIMO_TARGETS)
	@echo ''
	@echo '--- Building Primo A-32/48/64 Library ---'
	@echo ''
	TARGET=primo TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS -IXIY -DFORprimo -x$(OUTPUT_DIRECTORY)/primo_clib @$(TARGET_DIRECTORY)/primo/primo.lst





target-primo: $(PRIMO_TARGETS)

.PHONY: target-primo target-primo-clean



target-primo-clean:
	$(RM) -fr target/primo/obj
