
; void *zx_cy2saddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cy2saddr

EXTERN asm_zx_cy2saddr

defc zx_cy2saddr = asm_zx_cy2saddr
