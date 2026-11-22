SUPER80_SOURCES := $(call rwildcard,target/super80,*.asm) target/shared/copy_font.asm
SUPER80_TARGETS := target/super80/obj/target-super80-super80 \
	classic/video/mc6845/obj/super80

$(eval $(call gfx_stamp_args,super80,TARGET=super80 FLAVOUR="gencon narrow"))
$(eval $(call buildvideo,mc6845,MC6845,super80,))
CLEAN += target-super80-clean
TOCREATE += $(call check_target,super80,super80_clib.lib super80_vduem_clib.lib)
$(eval $(call buildtargetasm,target/super80,z80,super80,-mz80,$(SUPER80_SOURCES),$(SUPER80_SOURCES)))

super80_clib.lib: $(TARGET_CLIB_DEPS) $(SUPER80_TARGETS) classic/games/obj/.stamp-super80 classic/gfx/obj/.stamp-super80
	@echo ''
	@echo '--- Building Super80 Library ---'
	@echo ''
	TARGET=super80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsuper80 -x$(OUTPUT_DIRECTORY)/super80_clib @$(TARGET_DIRECTORY)/super80/super80.lst

super80_vduem_clib.lib: $(TARGET_CLIB_DEPS) super80_clib.lib $(SUPER80_TARGETS) classic/games/obj/.stamp-super80 classic/gfx/obj/.stamp-super80
	@echo ''
	@echo '--- Building Super80 VDUEM Library ---'
	@echo ''
	TARGET=super80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsuper80 -x$(OUTPUT_DIRECTORY)/super80_vduem_clib @$(TARGET_DIRECTORY)/super80/super80_vduem.lst

target-super80: $(SUPER80_TARGETS)

.PHONY: target-super80 target-super80-clean

target-super80-clean:
	$(RM) -fr target/super80/obj
