GAL_GLOBS := \
	"target/gal/*.asm" \
	"target/gal/games/*.asm" \
	"target/gal/graphics/*.asm" \
	"target/gal/interrupt/*.asm" \
	"target/gal/psg/*.asm" \
	"target/gal/stdio/*.asm" \
	"target/gal/stdio/ansi/*.asm" \
	"target/gal/time/*.asm" 

GAL_GLOBS_ex := \
	target/gal/*.asm \
	target/gal/games/*.asm \
	target/gal/graphics/*.asm \
	target/gal/interrupt/*.asm \
	target/gal/psg/*.asm \
	target/gal/stdio/*.asm \
	target/gal/stdio/ansi/*.asm \
	target/gal/time/*.asm 


GAL_TARGETS := target/gal/obj/target-gal-gal classic/games/obj/.stamp-gal classic/gfx/obj/.stamp-gal
		

CLEAN += target-gal-clean
TOCREATE += $(call check_target,gal,gal_clib.lib)
$(eval $(call gfx_stamp_args,gal,TARGET=gal))
$(eval $(call buildtargetasm,target/gal,z80,gal,-mz80,$(GAL_GLOBS),$(GAL_GLOBS_ex)))

gal_clib.lib: $(TARGET_CLIB_DEPS) $(GAL_TARGETS)
	@echo ''
	@echo '--- Building Galaksija Library ---'
	@echo ''
	TARGET=gal TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORgal -x$(OUTPUT_DIRECTORY)/gal_clib @$(TARGET_DIRECTORY)/gal/gal.lst



target-gal: $(GAL_TARGETS)

.PHONY: target-gal target-gal-clean



target-gal-clean:
	$(RM) -fr target/gal/obj
