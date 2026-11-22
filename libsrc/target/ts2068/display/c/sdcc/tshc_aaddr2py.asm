; uchar tshc_aaddr2py(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddr2py

EXTERN _zx_saddr2py

defc _tshc_aaddr2py = _zx_saddr2py
