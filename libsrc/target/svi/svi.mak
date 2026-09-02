SVI_SOURCES := $(shell find target/svi -type f \( -name '*.asm' -o -name '*.c' -o -name 'Makefile' \))

SVI_TARGETS := \
	target/svi/obj/target-svi-support \
	classic/video/tms9918/obj/svi \
	classic/video/mc6845/obj/svi \
	classic/games/obj/.stamp-svi \
	classic/gfx/obj/.stamp-svi

target/svi/obj/target-svi-support: $(SVI_SOURCES)
	$(Q)mkdir -p $(dir $@)
	$(MAKE) -C target/svi
	@touch $@

CLEAN += target-svi-clean

$(eval $(call gfx_stamp_args,svi,TARGET=svi))

target-svi: $(SVI_TARGETS)

.PHONY: target-svi target-svi-clean

classic/video/tms9918/obj/svi:
	$(Q)$(MAKE) -C classic/video/tms9918 TARGET=svi

classic/video/mc6845/obj/svi:
	$(Q)$(MAKE) -C classic/video/mc6845 TARGET=svi

target-svi-clean:
	$(RM) -fr target/svi/obj target/svi/rs232/obj target/svi/svibios/obj
