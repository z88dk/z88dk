
; uint zx_aaddr2cx(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_aaddr2cx

EXTERN asm_zx_aaddr2cx

defc zx_aaddr2cx = asm_zx_aaddr2cx
