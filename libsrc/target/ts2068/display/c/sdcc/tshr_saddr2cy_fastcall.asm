; uchar tshr_saddr2cy(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddr2cy_fastcall

EXTERN _zx_saddr2cy_fastcall

defc _tshr_saddr2cy_fastcall = _zx_saddr2cy_fastcall
