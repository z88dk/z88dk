; void *tshc_aaddrcright(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrcright

EXTERN zx_saddrcright

defc tshc_aaddrcright = zx_saddrcright

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_aaddrcright
defc _tshc_aaddrcright = tshc_aaddrcright
ENDIF

