; void *tshc_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrpup

EXTERN zx_saddrpup

defc tshc_saddrpup = zx_saddrpup

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_saddrpup
defc _tshc_saddrpup = tshc_saddrpup
ENDIF

