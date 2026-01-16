; void *tshc_saddr2aaddr(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddr2aaddr

EXTERN asm_tshc_saddr2aaddr

defc tshc_saddr2aaddr = asm_tshc_saddr2aaddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_saddr2aaddr
defc _tshc_saddr2aaddr = tshc_saddr2aaddr
ENDIF

