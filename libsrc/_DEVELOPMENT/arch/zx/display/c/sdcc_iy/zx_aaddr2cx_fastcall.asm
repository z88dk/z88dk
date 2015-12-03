
; uint zx_aaddr2cx_fastcall(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddr2cx_fastcall

EXTERN asm_zx_aaddr2cx

defc _zx_aaddr2cx_fastcall = asm_zx_aaddr2cx
