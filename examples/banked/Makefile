
all: binaries

include ../../support/multitarget_build/Makefile


BANK_TARGETS = msx gb
OUTPUT_BINS += $(foreach target, $(BANK_TARGETS),  build/$(target)/bank.bin )
CFLAGS_msx_bank = -subtype=rom -pragma-define:MAPPER_ASCII16

$(eval $(call build_app, $(BANK_TARGETS), bank.bin, main.c bank1.c bank2.c bank3.c bank4.c))




binaries: $(OUTPUT_BINS)
