; uchar tshr_bitmask2px(uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_bitmask2px_fastcall

EXTERN _zx_bitmask2px_fastcall

defc _tshr_bitmask2px_fastcall = _zx_bitmask2px_fastcall
