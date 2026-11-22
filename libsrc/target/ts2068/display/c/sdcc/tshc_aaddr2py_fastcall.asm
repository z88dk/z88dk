; uchar tshc_aaddr2py(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_aaddr2py_fastcall

EXTERN _zx_saddr2py_fastcall

defc _tshc_aaddr2py_fastcall = _zx_saddr2py_fastcall
