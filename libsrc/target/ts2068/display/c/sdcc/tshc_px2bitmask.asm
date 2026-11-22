; uchar tshc_px2bitmask(uchar x)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_px2bitmask

EXTERN _zx_px2bitmask

defc _tshc_px2bitmask = _zx_px2bitmask
