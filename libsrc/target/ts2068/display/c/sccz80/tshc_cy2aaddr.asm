; void *tshc_cy2aaddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cy2aaddr

EXTERN asm_tshc_cy2aaddr

defc tshc_cy2aaddr = asm_tshc_cy2aaddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_cy2aaddr
defc _tshc_cy2aaddr = tshc_cy2aaddr
ENDIF

