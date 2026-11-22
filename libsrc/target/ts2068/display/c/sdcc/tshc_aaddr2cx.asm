; uchar tshc_aaddr2cx(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddr2cx

EXTERN _zx_saddr2cx

defc _tshc_aaddr2cx = _zx_saddr2cx
