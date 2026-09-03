SVI_SOURCES := $(call rwildcard,target/svi,*.asm) $(call rwildcard,target/svi,*.c) $(call rwildcard,target/svi,Makefile)

SVI_TARGETS := \
	target/svi/obj/target-svi-support \
	classic/video/tms9918/obj/svi \
	classic/video/mc6845/obj/svi \
	classic/games/obj/.stamp-svi \
	classic/gfx/obj/.stamp-svi

CLEAN += target-svi-clean
TOCREATE += $(call check_target,svi,svi_clib.lib svibios.lib)
$(eval $(call gfx_stamp_args,svi,TARGET=svi))

svi_clib.lib: $(TARGET_CLIB_DEPS) msx_clib.lib $(SVI_TARGETS)
	TARGET=svi TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsvi -x$(OUTPUT_DIRECTORY)/svi_clib @$(TARGET_DIRECTORY)/svi/svi.lst

svibios.lib: $(TARGET_CLIB_DEPS) msx_clib.lib $(SVI_TARGETS)
	TARGET=svi TYPE=z80 $(LIBLINKER) -DFORsvi -x$(OUTPUT_DIRECTORY)/svibios @$(TARGET_DIRECTORY)/svi/arch_svibios.lst

target/svi/obj/target-svi-support: $(SVI_SOURCES)
	$(Q)mkdir -p $(dir $@)
	$(MAKE) -C target/svi
	@touch $@



target-svi: $(SVI_TARGETS)

.PHONY: target-svi target-svi-clean

classic/video/tms9918/obj/svi:
	$(Q)$(MAKE) -C classic/video/tms9918 TARGET=svi

classic/video/mc6845/obj/svi:
	$(Q)$(MAKE) -C classic/video/mc6845 TARGET=svi

target-svi-clean:
	$(RM) -fr target/svi/obj target/svi/rs232/obj target/svi/svibios/obj
