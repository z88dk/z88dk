
all: binaries


include ../../../support/multitarget_build/Makefile


WYZ_TARGETS = msx_rom zx cpc nabu mc1000 cpm_einstein lm80c ts2068 gal

OUTPUT_BINS += $(foreach target, $(WYZ_TARGETS),  build/$(target)/vt2eg.bin )

LDFLAGS_zx += -lndos
LDFLAGS_cpc += -lndos


$(eval $(call build_app, $(WYZ_TARGETS), vt2eg.bin, main.c sound.asm ))

binaries: $(OUTPUT_BINS)
