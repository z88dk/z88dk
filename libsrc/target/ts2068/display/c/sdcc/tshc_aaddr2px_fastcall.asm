; uchar tshc_aaddr2px(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddr2px_fastcall

EXTERN _zx_saddr2px_fastcall

defc _tshc_aaddr2px_fastcall = _zx_saddr2px_fastcall
