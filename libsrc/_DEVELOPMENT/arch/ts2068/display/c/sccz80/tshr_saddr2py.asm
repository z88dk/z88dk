; uchar tshr_saddr2py(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddr2py

EXTERN zx_saddr2py

defc tshr_saddr2py = zx_saddr2py
