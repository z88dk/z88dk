
; void *zx_cy2aaddr_fastcall(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cy2aaddr_fastcall

EXTERN asm_zx_cy2aaddr

defc _zx_cy2aaddr_fastcall = asm_zx_cy2aaddr
