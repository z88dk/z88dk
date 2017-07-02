; uchar tshr_px2bitmask(uchar x)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_px2bitmask

EXTERN zx_px2bitmask

defc tshr_px2bitmask = zx_px2bitmask
