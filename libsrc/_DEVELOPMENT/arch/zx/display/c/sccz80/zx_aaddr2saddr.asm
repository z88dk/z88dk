
; void *zx_aaddr2saddr(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_aaddr2saddr

EXTERN asm_zx_aaddr2saddr

defc zx_aaddr2saddr = asm_zx_aaddr2saddr
