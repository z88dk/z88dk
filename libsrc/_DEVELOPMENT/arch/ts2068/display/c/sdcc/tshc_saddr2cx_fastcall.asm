; uchar tshc_saddr2cx(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddr2cx_fastcall

EXTERN _zx_saddr2cx_fastcall

defc _tshc_saddr2cx_fastcall = _zx_saddr2cx_fastcall
