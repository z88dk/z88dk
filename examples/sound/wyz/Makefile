
all: binaries


include ../../../support/multitarget_build/Makefile


WYZ_TARGETS = msx_rom zx cpc nabu multi8 sam mc1000 myvision pc88 cpm_einstein lm80c pc6001 ts2068 gal

OUTPUT_BINS += $(foreach target, $(WYZ_TARGETS),  build/$(target)/wyzeg.bin )

LDFLAGS_zx += -lndos
LDFLAGS_cpc += -lndos


$(eval $(call build_app, $(WYZ_TARGETS), wyzeg.bin, main.c sham.mus.asm effects.asm ))

binaries: $(OUTPUT_BINS)
