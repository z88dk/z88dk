
; uint zx_aaddr2px_fastcall(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddr2px_fastcall

EXTERN asm_zx_aaddr2px

defc _zx_aaddr2px_fastcall = asm_zx_aaddr2px
