; uchar tshc_saddr2px(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddr2px_fastcall

EXTERN _zx_saddr2px_fastcall

defc _tshc_saddr2px_fastcall = _zx_saddr2px_fastcall
