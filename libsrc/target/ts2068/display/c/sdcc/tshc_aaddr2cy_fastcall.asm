; uchar tshc_aaddr2cy(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddr2cy_fastcall

EXTERN _zx_saddr2cy_fastcall

defc _tshc_aaddr2cy_fastcall = _zx_saddr2cy_fastcall
