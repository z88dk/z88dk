
all: binaries


include ../../../support/multitarget_build/Makefile


ARKOS_INT_TARGETS = msx_rom zx cpc
ARKOS_PERIODIC_TARGETS = msx_rom zx cpc

ARKOS_ROM_INT_TARGETS = msx_rom zx cpc
ARKOS_ROM_PERIODIC_TARGETS = msx_rom zx cpc

OUTPUT_BINS += $(foreach target, $(ARKOS_INT_TARGETS),  build/$(target)/arkint.bin )
OUTPUT_BINS += $(foreach target, $(ARKOS_PERIODIC_TARGETS),  build/$(target)/arkper.bin )
OUTPUT_BINS += $(foreach target, $(ARKOS_ROM_INT_TARGETS),  build/$(target)/arkromint.bin )
OUTPUT_BINS += $(foreach target, $(ARKOS_ROM_PERIODIC_TARGETS),  build/$(target)/arkromper.bin )


CFLAGS_cpc = -subtype=dsk

$(eval $(call build_app, $(ARKOS_INT_TARGETS), arkint.bin, arkos_interrupt.c ))
$(eval $(call build_app, $(ARKOS_PERIODIC_TARGETS), arkper.bin, arkos_periodic.c ))

$(eval $(call build_app, $(ARKOS_ROM_INT_TARGETS), arkromint.bin, arkos_rominterrupt.c ))
$(eval $(call build_app, $(ARKOS_ROM_PERIODIC_TARGETS), arkromper.bin, arkos_romperiodic.c ))


binaries: $(OUTPUT_BINS)
