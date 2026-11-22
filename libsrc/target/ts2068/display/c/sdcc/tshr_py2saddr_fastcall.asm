; void *tshr_py2saddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_py2saddr_fastcall

EXTERN _zx_py2saddr_fastcall

defc _tshr_py2saddr_fastcall = _zx_py2saddr_fastcall
