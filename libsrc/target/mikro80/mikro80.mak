MIKRO80_GLOBS := \
	"target/mikro80/games/*.asm" \
	"target/mikro80/graphics/*.asm" \
	"target/mikro80/input/*.asm" \
	"target/mikro80/stdio/*.asm" 

MIKRO80_GLOBS_ex := \
	target/mikro80/games/*.asm \
	target/mikro80/graphics/*.asm \
	target/mikro80/input/*.asm \
	target/mikro80/stdio/*.asm 


MIKRO80_TARGETS := target/mikro80/obj/target-mikro80-mikro80 classic/games/obj/.stamp-mikro80 classic/gfx/obj/.stamp-mikro80
		

CLEAN += target-mikro80-clean
TOCREATE += $(call check_target,mikro80,mikro80_clib.lib)
$(eval $(call gfx_stamp_args,mikro80,TARGET=mikro80 FLAVOUR="gencon narrow"))
$(eval $(call buildtargetasm,target/mikro80,8080,mikro80,-m8080,$(MIKRO80_GLOBS),$(MIKRO80_GLOBS_ex)))

mikro80_clib.lib: $(TARGET_CLIB_DEPS) $(MIKRO80_TARGETS)
	@echo ''
	@echo '--- Building Mikro80 Library ---'
	@echo ''
	TARGET=mikro80 TYPE=8080 $(LIBLINKER) -m8080 -DFORmikro80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/mikro80_clib @$(TARGET_DIRECTORY)/mikro80/mikro80.lst



target-mikro80: $(MIKRO80_TARGETS)

.PHONY: target-mikro80 target-mikro80-clean



target-mikro80-clean:
	$(RM) -fr target/mikro80/obj
