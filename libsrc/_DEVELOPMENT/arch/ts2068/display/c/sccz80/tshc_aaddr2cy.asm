; uchar tshc_aaddr2cy(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddr2cy

EXTERN zx_saddr2cy

defc tshc_aaddr2cy = zx_saddr2cy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_aaddr2cy
defc _tshc_aaddr2cy = tshc_aaddr2cy
ENDIF

