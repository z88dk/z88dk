; uchar tshr_bitmask2px(uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_bitmask2px

EXTERN zx_bitmask2px

defc tshr_bitmask2px = zx_bitmask2px
