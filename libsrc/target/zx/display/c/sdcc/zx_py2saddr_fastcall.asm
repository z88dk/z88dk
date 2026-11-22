
; void *zx_py2saddr_fastcall(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_py2saddr_fastcall

EXTERN asm_zx_py2saddr

defc _zx_py2saddr_fastcall = asm_zx_py2saddr
