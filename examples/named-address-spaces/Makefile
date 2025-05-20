
all: binaries

include ../../support/multitarget_build/Makefile


NASPACE_TARGETS = zx msx
OUTPUT_BINS += $(foreach target, $(NASPACE_TARGETS),  build/$(target)/naspace.bin )
CFLAGS_zx_naspace = -lndos 

CFLAGS_msx_naspace = -subtype=msxdos2 -pragma-define:CRT_DISABLELOADER=0 

$(eval $(call build_app, $(NASPACE_TARGETS), naspace.bin, main.c bank1.c bank4.c))


binaries: $(OUTPUT_BINS)
