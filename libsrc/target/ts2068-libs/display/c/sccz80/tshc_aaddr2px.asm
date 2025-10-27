; uchar tshc_aaddr2px(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddr2px

EXTERN zx_saddr2px

defc tshc_aaddr2px = zx_saddr2px

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_aaddr2px
defc _tshc_aaddr2px = tshc_aaddr2px
ENDIF

