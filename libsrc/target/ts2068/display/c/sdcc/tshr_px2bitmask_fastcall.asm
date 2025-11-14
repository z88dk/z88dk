; uchar tshr_px2bitmask(uchar x)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_px2bitmask_fastcall

EXTERN _zx_px2bitmask_fastcall

defc _tshr_px2bitmask_fastcall = _zx_px2bitmask_fastcall
