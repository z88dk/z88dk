HDOS_SOURCES := $(shell find target/hdos -type f -name '*.asm')
HDOS_CFILES := $(shell find target/hdos -type f -name '*.c')
HDOS_OFILES := $(patsubst target/hdos/%,target/hdos/obj/hdos/%,$(HDOS_CFILES:.c=.o))

HDOS_TARGETS := target/hdos/obj/target-hdos-hdos $(HDOS_OFILES) classic/gfx/obj/.stamp-h19

CLEAN += target-hdos-clean
hdos_clib.lib: $(TARGET_CLIB_DEPS) gfxh19.lib $(HDOS_TARGETS)
	@echo ''
	@echo '--- Building Heath/Zenith HDOS ---'
	@echo ''
	TARGET=hdos TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhdos -x$(OUTPUT_DIRECTORY)/hdos_clib @$(TARGET_DIRECTORY)/hdos/hdos.lst

TOCREATE += $(call check_target,hdos,hdos_clib.lib)

$(eval $(call gfx_stamp_args,h19,TARGET=cpm SUBTYPE=h19 FLAVOUR="gencon text narrow"))

target-hdos: $(HDOS_TARGETS)

.PHONY: target-hdos target-hdos-clean

$(eval $(call buildtargetasm,target/hdos,z80,hdos,-mz80,$(HDOS_SOURCES),$(HDOS_SOURCES)))
$(eval $(call buildtargetc,target/hdos,hdos))

target-hdos-clean:
	$(RM) -fr target/hdos/obj
