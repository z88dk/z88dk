; uchar tshr_saddr2py(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddr2py

EXTERN _zx_saddr2py

defc _tshr_saddr2py = _zx_saddr2py
