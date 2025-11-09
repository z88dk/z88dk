; void *tshc_aaddrpleft(void *aaddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrpleft

EXTERN zx_saddrpleft

defc tshc_aaddrpleft = zx_saddrpleft

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_aaddrpleft
defc _tshc_aaddrpleft = tshc_aaddrpleft
ENDIF

