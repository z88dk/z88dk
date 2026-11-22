TRS80_GRAFYX_SOURCES := $(call rwildcard,target/trs80/grafyx,*.asm)
TRS80_SOURCES := $(filter-out $(TRS80_GRAFYX_SOURCES),$(call rwildcard,target/trs80,*.asm))
TRS80_CFILES := $(call rwildcard,target/trs80,*.c)
TRS80_OFILES := $(patsubst target/trs80/%,target/trs80/obj/trs80/%,$(TRS80_CFILES:.c=.o))

TRS80_MC6845_SOURCES := $(wildcard classic/video/mc6845/*.asm)
TRS80_MC6845_OBJECTS := $(patsubst classic/video/mc6845/%.asm,classic/video/mc6845/obj/trs80/%.o,$(TRS80_MC6845_SOURCES))
TRS80M2_MC6845_OBJECTS := $(patsubst classic/video/mc6845/%.asm,classic/video/mc6845/obj/trs80m2/%.o,$(TRS80_MC6845_SOURCES))

TRS80_TARGETS := target/trs80/obj/target-trs80-trs80 $(TRS80_OFILES) $(TRS80_MC6845_OBJECTS) classic/games/obj/.stamp-trs80 classic/gfx/obj/.stamp-trs80-base classic/gfx/obj/.stamp-trs80
GRAFYX3_TARGETS := target/trs80/obj/target-trs80-grafyx3
GRAFYX4_TARGETS := target/trs80/obj/target-trs80-grafyx4
TRSDOS_CFILES := $(notdir $(wildcard target/trs80/fcntl/*.c))
TRSDOS_AFILES := $(notdir $(wildcard target/trs80/fcntl/*.asm))
TRSDOS_COBJECTS := $(addprefix target/trs80/fcntl/obj/,$(TRSDOS_CFILES:.c=.o))
TRSDOS_AOBJECTS := $(addprefix target/trs80/fcntl/obj/,$(TRSDOS_AFILES:.asm=.o))
TRSDOS_OBJECTS := $(TRSDOS_COBJECTS) $(TRSDOS_AOBJECTS)
CLEAN += target-trs80-clean
TOCREATE += $(call check_target,trs80, trs80_clib.lib trsdos.lib gfxtrs80.lib gfxtrs80m2.lib gfxtrs80m4.lib gfxeg2000.lib grafyx4_3.lib grafyx4.lib gfxhrg1.lib trs80_cpm.lib)
$(eval $(call gfx_stamp_args,trs80,TARGET=trs80 FLAVOUR="text6 narrow"))
$(eval $(call gfx_stamp_args,trs80-base,TARGET=trs80))
$(eval $(call gfx_stamp_args,trs80m2,TARGET=trs80 FLAVOUR="gencon text6 narrow" SUBTYPE=trs80m2))
$(eval $(call gfx_stamp_args,trs80m4,TARGET=trs80 FLAVOUR="text6 narrow" SUBTYPE=trs80m4))
$(eval $(call gfx_stamp_args,eg2000,TARGET=trs80 FLAVOUR=narrow SUBTYPE=eg2000))
$(eval $(call gfx_stamp_args,hrg1,TARGET=trs80 FLAVOUR=wide SUBTYPE=hrg1))
$(eval $(call gfx_stamp_args,grafyx3,TARGET=trs80 FLAVOUR=wide SUBTYPE=grafyx3))
$(eval $(call gfx_stamp_args,grafyx4,TARGET=trs80 FLAVOUR=wide SUBTYPE=grafyx4))
$(eval $(call buildtargetasm,target/trs80,z80,trs80,-mz80,$(TRS80_SOURCES),$(TRS80_SOURCES)))
$(eval $(call buildtargetc,target/trs80,trs80))
define buildgrafyxasm
target/trs80/obj/target-trs80-$(1): $(TRS80_GRAFYX_SOURCES)
	$(Q)mkdir -p target/trs80/obj/$(1)
	$(Q)$(ASSEMBLER) -d -O=target/trs80/obj/$(1)/x -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I$(Z88DK_LIBSRC)/target/trs80 -I$(Z88DK_LIB) -I$(Z88DK_LIB)/target/trs80/def -Itarget/trs80 -Itarget/trs80/obj/$(1) -I$(Z88DK_LIBSRC)/classic -mz80 -DSTANDARDESCAPECHARS -D__CLASSIC -DFOR$(1) $(TRS80_GRAFYX_SOURCES)
	$(Q)touch $$@
endef
$(eval $(call buildgrafyxasm,grafyx3))
$(eval $(call buildgrafyxasm,grafyx4))

$(TRS80_MC6845_OBJECTS): classic/video/mc6845/obj/trs80/%.o: classic/video/mc6845/%.asm
	$(Q)mkdir -p $(@D)
	$(Q)$(ASSEMBLER) -DFORtrs80 -Iclassic/video/mc6845 -o=$@ $<

$(TRS80M2_MC6845_OBJECTS): classic/video/mc6845/obj/trs80m2/%.o: classic/video/mc6845/%.asm
	$(Q)mkdir -p $(@D)
	$(Q)$(ASSEMBLER) -DFORtrs80m2 -Iclassic/video/mc6845 -o=$@ $<



trsdos.lib: $(TRSDOS_OBJECTS)
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/trsdos @target/trs80/fcntl/trsdos.lst

$(TRSDOS_OBJECTS):
	$(MAKE) -C target/trs80/fcntl obj/$(@F)

trs80_clib.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS)
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORtrs80 -x$(OUTPUT_DIRECTORY)/trs80_clib @$(TARGET_DIRECTORY)/trs80/trs80.lst
	@touch $@

trs80_cpm.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS)
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/trs80_cpm @$(TARGET_DIRECTORY)/trs80/trs80_cpm.lst
	@touch $@

gfxtrs80.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS)
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/gfxtrs80 @$(TARGET_DIRECTORY)/trs80/gfxtrs80.lst
	@touch $@

gfxtrs80m2.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS) $(TRS80M2_MC6845_OBJECTS) classic/gfx/obj/.stamp-trs80m2
	TARGET=trs80m2 TYPE=z80 $(LIBLINKER) -DFORtrs80m2 -x$(OUTPUT_DIRECTORY)/gfxtrs80m2 @$(TARGET_DIRECTORY)/trs80/gfxtrs80m2.lst
	@touch $@

gfxtrs80m4.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS) classic/gfx/obj/.stamp-trs80m4
	TARGET=trs80m4 TYPE=z80 $(LIBLINKER) -DFORtrs80m4 -x$(OUTPUT_DIRECTORY)/gfxtrs80m4 @$(TARGET_DIRECTORY)/trs80/gfxtrs80m4.lst
	@touch $@

gfxeg2000.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS) classic/gfx/obj/.stamp-eg2000
	TARGET=eg2000 TYPE=z80 $(LIBLINKER) -DFOReg2000 -x$(OUTPUT_DIRECTORY)/gfxeg2000 @$(TARGET_DIRECTORY)/trs80/gfxeg2000.lst
	@touch $@

gfxhrg1.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS) classic/gfx/obj/.stamp-hrg1
	TARGET=hrg1 TYPE=z80 $(LIBLINKER) -DFORhrg1 -x$(OUTPUT_DIRECTORY)/gfxhrg1 @$(TARGET_DIRECTORY)/trs80/gfxhrg1.lst
	@touch $@

grafyx4_3.lib:  $(TARGET_CLIB_DEPS) $(GRAFYX3_TARGETS) classic/games/obj/.stamp-trs80 classic/gfx/obj/.stamp-trs80-base classic/gfx/obj/.stamp-grafyx3
	TARGET=grafyx3 TYPE=z80 $(LIBLINKER) -DFORgrafyx3 -x$(OUTPUT_DIRECTORY)/grafyx4_3 @$(TARGET_DIRECTORY)/trs80/grafyx.lst
	@touch $@

grafyx4.lib:  $(TARGET_CLIB_DEPS) $(GRAFYX4_TARGETS) classic/games/obj/.stamp-trs80 classic/gfx/obj/.stamp-trs80-base classic/gfx/obj/.stamp-grafyx4
	TARGET=grafyx4 TYPE=z80 $(LIBLINKER) -DFORgrafyx4 -x$(OUTPUT_DIRECTORY)/grafyx4 @$(TARGET_DIRECTORY)/trs80/grafyx.lst
	@touch $@


target-trs80: $(TRS80_TARGETS)

.PHONY: target-trs80 target-trs80-clean


target-trs80-clean:
	$(RM) -fr target/trs80/obj
