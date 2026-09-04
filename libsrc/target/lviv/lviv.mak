LVIV_GLOBS := \
	"target/lviv/games/*.asm" \
	"target/lviv/graphics/*.asm" \
	"target/lviv/input/*.asm" \
	"target/lviv/stdio/*.asm" 

LVIV_GLOBS_ex := \
	target/lviv/games/*.asm \
	target/lviv/graphics/*.asm \
	target/lviv/input/*.asm \
	target/lviv/stdio/*.asm 


LVIV_TARGETS := target/lviv/obj/target-lviv-lviv classic/games/obj/.stamp-lviv classic/gfx/obj/.stamp-lviv
		

CLEAN += target-lviv-clean
TOCREATE += $(call check_target,lviv,lviv_clib.lib)
$(eval $(call gfx_stamp_portable_args,lviv,TARGET=lviv FLAVOUR=narrow))
$(eval $(call buildtargetasm,target/lviv,8080,lviv,-m8080,$(LVIV_GLOBS),$(LVIV_GLOBS_ex)))

lviv_clib.lib: $(TARGET_CLIB_DEPS) $(LVIV_TARGETS)
	@echo ''
	@echo '--- Building PK-01 Lviv/Lvov Library ---'
	@echo ''
	TARGET=lviv TYPE=8080 $(LIBLINKER) -m8080 -DFORlviv -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/lviv_clib @$(TARGET_DIRECTORY)/lviv/lviv.lst



target-lviv: $(LVIV_TARGETS)

.PHONY: target-lviv target-lviv-clean



target-lviv-clean:
	$(RM) -fr target/lviv/obj
