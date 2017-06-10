; uchar tshc_saddr2cx(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddr2cx

EXTERN _zx_saddr2cx

defc _tshc_saddr2cx = _zx_saddr2cx
