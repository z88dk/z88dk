; uchar tshc_bitmask2px(uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_bitmask2px

EXTERN _zx_bitmask2px

defc _tshc_bitmask2px = _zx_bitmask2px
