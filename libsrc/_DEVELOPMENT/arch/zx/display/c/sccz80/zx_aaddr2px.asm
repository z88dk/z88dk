
; uint zx_aaddr2px(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_aaddr2px

EXTERN asm_zx_aaddr2px

defc zx_aaddr2px = asm_zx_aaddr2px
