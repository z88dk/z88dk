SVI_SOURCES := $(shell find target/svi -type f \( -name '*.asm' -o -name '*.c' -o -name 'Makefile' \))

SVI_TARGETS := \
	target/svi/obj/target-svi-support \
	classic/games/obj/.stamp-svi \
	classic/gfx/obj/.stamp-svi

target/svi/obj/target-svi-support: $(SVI_SOURCES)
	@mkdir -p $(dir $@)
	$(MAKE) -C target/svi
	@touch $@

CLEAN += target-svi-clean

$(eval $(call gfx_stamp_args,svi,TARGET=svi))

target-svi: $(SVI_TARGETS)

.PHONY: target-svi target-svi-clean

target-svi-clean:
	$(RM) -fr target/svi/obj target/svi/rs232/obj target/svi/svibios/obj
