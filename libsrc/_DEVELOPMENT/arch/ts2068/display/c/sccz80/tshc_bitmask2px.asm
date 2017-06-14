; uchar tshc_bitmask2px(uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_bitmask2px

EXTERN zx_bitmask2px

defc tshc_bitmask2px = zx_bitmask2px
