TRS80_SOURCES := $(shell find target/trs80 -type f -name '*.asm')
TRS80_CFILES := $(shell find target/trs80 -type f -name '*.c')
TRS80_OFILES := $(patsubst target/trs80/%,target/trs80/obj/trs80/%,$(TRS80_CFILES:.c=.o))

TRS80_MC6845_SOURCES := $(wildcard classic/video/mc6845/*.asm)
TRS80_MC6845_OBJECTS := $(patsubst classic/video/mc6845/%.asm,classic/video/mc6845/obj/trs80/%.o,$(TRS80_MC6845_SOURCES))
TRS80M2_MC6845_OBJECTS := $(patsubst classic/video/mc6845/%.asm,classic/video/mc6845/obj/trs80m2/%.o,$(TRS80_MC6845_SOURCES))

$(TRS80_MC6845_OBJECTS): classic/video/mc6845/obj/trs80/%.o: classic/video/mc6845/%.asm
	$(Q)mkdir -p $(@D)
	$(Q)$(ASSEMBLER) -DFORtrs80 -Iclassic/video/mc6845 -o=$@ $<

$(TRS80M2_MC6845_OBJECTS): classic/video/mc6845/obj/trs80m2/%.o: classic/video/mc6845/%.asm
	$(Q)mkdir -p $(@D)
	$(Q)$(ASSEMBLER) -DFORtrs80m2 -Iclassic/video/mc6845 -o=$@ $<

TRS80_TARGETS := target/trs80/obj/target-trs80-trs80 $(TRS80_OFILES) $(TRS80_MC6845_OBJECTS) classic/games/obj/.stamp-trs80 classic/gfx/obj/.stamp-trs80-base classic/gfx/obj/.stamp-trs80

TRSDOS_CFILES := $(notdir $(wildcard target/trs80/fcntl/*.c))
TRSDOS_AFILES := $(notdir $(wildcard target/trs80/fcntl/*.asm))
TRSDOS_COBJECTS := $(addprefix target/trs80/fcntl/obj/,$(TRSDOS_CFILES:.c=.o))
TRSDOS_AOBJECTS := $(addprefix target/trs80/fcntl/obj/,$(TRSDOS_AFILES:.asm=.o))
TRSDOS_OBJECTS := $(TRSDOS_COBJECTS) $(TRSDOS_AOBJECTS)

trsdos.lib: $(TRSDOS_OBJECTS)
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/trsdos @target/trs80/fcntl/trsdos.lst

$(TRSDOS_OBJECTS):
	$(MAKE) -C target/trs80/fcntl obj/$(@F)

CLEAN += target-trs80-clean

$(eval $(call gfx_stamp_args,trs80,TARGET=trs80 FLAVOUR="text6 narrow"))
$(eval $(call gfx_stamp_args,trs80-base,TARGET=trs80))
$(eval $(call gfx_stamp_args,trs80m2,TARGET=trs80 FLAVOUR="gencon text6 narrow" SUBTYPE=trs80m2))
$(eval $(call gfx_stamp_args,trs80m4,TARGET=trs80 FLAVOUR="text6 narrow" SUBTYPE=trs80m4))
$(eval $(call gfx_stamp_args,eg2000,TARGET=trs80 FLAVOUR=narrow SUBTYPE=eg2000))
$(eval $(call gfx_stamp_args,hrg1,TARGET=trs80 FLAVOUR=wide SUBTYPE=hrg1))
$(eval $(call gfx_stamp_args,grafyx3,TARGET=trs80 FLAVOUR=wide SUBTYPE=grafyx3))
$(eval $(call gfx_stamp_args,grafyx4,TARGET=trs80 FLAVOUR=wide SUBTYPE=grafyx4))

target-trs80: $(TRS80_TARGETS)

.PHONY: target-trs80 target-trs80-clean

$(eval $(call buildtargetasm,target/trs80,z80,trs80,-mz80,$(TRS80_SOURCES),$(TRS80_SOURCES)))
$(eval $(call buildtargetc,target/trs80,trs80))

target-trs80-clean:
	$(RM) -fr target/trs80/obj
