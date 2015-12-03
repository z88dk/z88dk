
; void *zx_saddr2aaddr_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddr2aaddr_fastcall

EXTERN asm_zx_saddr2aaddr

defc _zx_saddr2aaddr_fastcall = asm_zx_saddr2aaddr
