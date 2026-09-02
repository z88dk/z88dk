AQUARIUS_SOURCES := $(shell find target/aquarius -type f -name '*.asm')
AQUARIUS_CFILES := $(shell find target/aquarius -type f -name '*.c')
AQUARIUS_OFILES := $(patsubst target/aquarius/%,target/aquarius/obj/aquarius/%,$(AQUARIUS_CFILES:.c=.o))

AQUARIUS_TARGETS := target/aquarius/obj/target-aquarius-aquarius $(AQUARIUS_OFILES) classic/games/obj/.stamp-aquarius classic/gfx/obj/.stamp-aquarius

CLEAN += target-aquarius-clean
aquarius_clib.lib: $(TARGET_CLIB_DEPS) $(AQUARIUS_TARGETS)
	@echo ''
	@echo '--- Building Mattel Aquarius Library (& 80x72 GFX) ---'
	@echo ''
	TARGET=aquarius TYPE=z80 $(LIBLINKER) -DFORaquarius -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/aquarius_clib.lib @$(TARGET_DIRECTORY)/aquarius/aquarius.lst

gfxaq48.lib: $(TARGET_CLIB_DEPS) aquarius_clib.lib classic/gfx/obj/.stamp-aq48
	@echo ''
	@echo '--- Building Mattel Aquarius 80x48 Graphics lib ---'
	@echo ''
	TARGET=aq48 TYPE=z80 $(LIBLINKER) -DFORaq48 -x$(OUTPUT_DIRECTORY)/gfxaq48 @$(TARGET_DIRECTORY)/aquarius/gfxaq48.lst

aqplus.lib: $(TARGET_CLIB_DEPS) aquarius_clib.lib classic/gfx/obj/.stamp-aqplus
	@echo ''
	@echo '--- Building Mattel Aquarius Plus lib ---'
	@echo ''
	TARGET=aqplus TYPE=z80 $(LIBLINKER) -DFORaqplus -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/aqplus @$(TARGET_DIRECTORY)/aquarius/aqplus.lst


TOCREATE += $(call check_target,aquarius,aquarius_clib.lib gfxaq48.lib aqplus.lib)

$(eval $(call gfx_stamp_args,aquarius,TARGET=aquarius FLAVOUR="text6 narrow"))
$(eval $(call gfx_stamp_args,aq48,TARGET=aquarius SUBTYPE=aq48 FLAVOUR="text narrow"))
$(eval $(call gfx_stamp_args,aqplus,TARGET=aquarius SUBTYPE=aqplus FLAVOUR=wide))

target-aquarius: $(AQUARIUS_TARGETS)

.PHONY: target-aquarius target-aquarius-clean

$(eval $(call buildtargetasm,target/aquarius,z80,aquarius,-mz80,$(AQUARIUS_SOURCES),$(AQUARIUS_SOURCES)))
$(eval $(call buildtargetc,target/aquarius,aquarius))

target-aquarius-clean:
	$(RM) -fr target/aquarius/obj
