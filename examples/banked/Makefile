
all: binaries

include ../../support/multitarget_build/Makefile


BANK_TARGETS = msx gb zx sms cpc aquarius
OUTPUT_BINS += $(foreach target, $(BANK_TARGETS),  build/$(target)/bank.bin )
CFLAGS_msx_bank = -subtype=rom -pragma-define:MAPPER_ASCII16
CFLAGS_zx_bank = -lndos
CFLAGS_sms_bank = --generic-console -pragma-redirect:CRT_FONT=_font_8x8_zx_system -pragma-define:CRT_ENABLE_BANKED_CALLS=1
CFLAGS_cpc_bank = -lndos --generic-console -pragma-redirect:CRT_FONT=_font_8x8_zx_system -subtype=dsk
CFLAGS_aquarius_bank = -subtype=banked -pragma-string:basename=bank --generic-console 

$(eval $(call build_app, $(BANK_TARGETS), bank.bin, main.c bank1.c bank2.c bank3.c bank4.c))




binaries: $(OUTPUT_BINS)
