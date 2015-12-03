
; uint zx_aaddr2cy(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_aaddr2cy

EXTERN asm_zx_aaddr2cy

defc zx_aaddr2cy = asm_zx_aaddr2cy
