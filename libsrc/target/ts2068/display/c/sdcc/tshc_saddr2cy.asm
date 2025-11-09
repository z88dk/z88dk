; uchar tshc_saddr2cy(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddr2cy

EXTERN _zx_saddr2cy

defc _tshc_saddr2cy = _zx_saddr2cy
