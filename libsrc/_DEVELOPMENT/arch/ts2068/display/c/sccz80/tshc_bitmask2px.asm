; uchar tshc_bitmask2px(uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_bitmask2px

EXTERN zx_bitmask2px

defc tshc_bitmask2px = zx_bitmask2px

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_bitmask2px
defc _tshc_bitmask2px = tshc_bitmask2px
ENDIF

