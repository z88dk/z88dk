
; void *zx_aaddrcdown(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_aaddrcdown

EXTERN asm_zx_aaddrcdown

defc zx_aaddrcdown = asm_zx_aaddrcdown
