; void *tshc_aaddrpdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrpdown

EXTERN zx_saddrpdown

defc tshc_aaddrpdown = zx_saddrpdown

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_aaddrpdown
defc _tshc_aaddrpdown = tshc_aaddrpdown
ENDIF

