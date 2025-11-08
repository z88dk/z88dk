; void *tshc_aaddrcleft(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrcleft

EXTERN zx_saddrcleft

defc tshc_aaddrcleft = zx_saddrcleft

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_aaddrcleft
defc _tshc_aaddrcleft = tshc_aaddrcleft
ENDIF

