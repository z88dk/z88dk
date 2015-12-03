
; uint zx_aaddr2cy_fastcall(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddr2cy_fastcall

EXTERN asm_zx_aaddr2cy

defc _zx_aaddr2cy_fastcall = asm_zx_aaddr2cy
