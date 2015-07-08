
; void *zx_aaddr2saddr_fastcall(void *attraddr)

SECTION code_arch

PUBLIC _zx_aaddr2saddr_fastcall

EXTERN asm_zx_aaddr2saddr

defc _zx_aaddr2saddr_fastcall = asm_zx_aaddr2saddr
