; void *tshc_saddrpright(void *saddr, uint bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrpright

EXTERN zx_saddrpright

defc tshc_saddrpright = zx_saddrpright

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_saddrpright
defc _tshc_saddrpright = tshc_saddrpright
ENDIF

