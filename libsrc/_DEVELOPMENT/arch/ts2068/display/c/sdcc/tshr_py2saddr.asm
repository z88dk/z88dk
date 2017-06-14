; void *tshr_py2saddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_py2saddr

EXTERN _zx_py2saddr

defc _tshr_py2saddr = _zx_py2saddr
