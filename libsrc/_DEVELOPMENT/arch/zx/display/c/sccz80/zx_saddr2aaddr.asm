
; void *zx_saddr2aaddr(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddr2aaddr

EXTERN asm_zx_saddr2aaddr

defc zx_saddr2aaddr = asm_zx_saddr2aaddr
