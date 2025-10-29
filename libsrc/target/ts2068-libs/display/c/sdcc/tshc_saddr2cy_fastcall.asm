; uchar tshc_saddr2cy(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddr2cy_fastcall

EXTERN _zx_saddr2cy_fastcall

defc _tshc_saddr2cy_fastcall = _zx_saddr2cy_fastcall
