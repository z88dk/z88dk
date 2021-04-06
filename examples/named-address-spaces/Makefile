
all: binaries

include ../../support/multitarget_build/Makefile


NASPACE_TARGETS = zx
OUTPUT_BINS += $(foreach target, $(NASPACE_TARGETS),  build/$(target)/naspace.bin )
CFLAGS_zx_naspace = -lndos

$(eval $(call build_app, $(NASPACE_TARGETS), naspace.bin, main.c bank1.c bank4.c page.asm))


binaries: $(OUTPUT_BINS)
