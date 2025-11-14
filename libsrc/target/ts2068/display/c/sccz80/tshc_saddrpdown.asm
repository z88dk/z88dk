; void *tshc_saddrpdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrpdown

EXTERN zx_saddrpdown

defc tshc_saddrpdown = zx_saddrpdown

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_saddrpdown
defc _tshc_saddrpdown = tshc_saddrpdown
ENDIF

