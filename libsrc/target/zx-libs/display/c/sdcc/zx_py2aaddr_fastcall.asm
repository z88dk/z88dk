
; void *zx_py2aaddr_fastcall(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_py2aaddr_fastcall

EXTERN asm_zx_py2aaddr

defc _zx_py2aaddr_fastcall = asm_zx_py2aaddr
