; void *tshc_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddrpleft

EXTERN zx_saddrpleft

defc tshc_saddrpleft = zx_saddrpleft

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_saddrpleft
defc _tshc_saddrpleft = tshc_saddrpleft
ENDIF

