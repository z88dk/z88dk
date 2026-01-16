; void *tshc_saddrcleft(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrcleft

EXTERN zx_saddrcleft

defc tshc_saddrcleft = zx_saddrcleft

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_saddrcleft
defc _tshc_saddrcleft = tshc_saddrcleft
ENDIF

