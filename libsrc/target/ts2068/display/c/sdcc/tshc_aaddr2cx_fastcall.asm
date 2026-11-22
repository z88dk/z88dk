; uchar tshc_aaddr2cx(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddr2cx_fastcall

EXTERN _zx_saddr2cx_fastcall

defc _tshc_aaddr2cx_fastcall = _zx_saddr2cx_fastcall
