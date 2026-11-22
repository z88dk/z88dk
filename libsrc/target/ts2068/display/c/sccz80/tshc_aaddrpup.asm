; void *tshc_aaddrpup(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrpup

EXTERN zx_saddrpup

defc tshc_aaddrpup = zx_saddrpup

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_aaddrpup
defc _tshc_aaddrpup = tshc_aaddrpup
ENDIF

