; void *tshc_aaddr2saddr(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddr2saddr

EXTERN asm_tshc_aaddr2saddr

defc tshc_aaddr2saddr = asm_tshc_aaddr2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_aaddr2saddr
defc _tshc_aaddr2saddr = tshc_aaddr2saddr
ENDIF

