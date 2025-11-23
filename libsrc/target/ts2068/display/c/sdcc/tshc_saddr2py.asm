; uchar tshc_saddr2py(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddr2py

EXTERN _zx_saddr2py

defc _tshc_saddr2py = _zx_saddr2py
