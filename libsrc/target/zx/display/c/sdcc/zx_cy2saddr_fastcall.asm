
; void *zx_cy2saddr_fastcall(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cy2saddr_fastcall

EXTERN asm_zx_cy2saddr

defc _zx_cy2saddr_fastcall = asm_zx_cy2saddr
