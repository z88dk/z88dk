
; void *zx_cy2aaddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cy2aaddr

EXTERN asm_zx_cy2aaddr

defc zx_cy2aaddr = asm_zx_cy2aaddr
