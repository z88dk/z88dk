; uchar tshc_aaddr2cy(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddr2cy

EXTERN _zx_saddr2cy

defc _tshc_aaddr2cy = _zx_saddr2cy
