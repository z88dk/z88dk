
; void *zx_aaddrcright(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_aaddrcright

EXTERN asm_zx_aaddrcright

defc zx_aaddrcright = asm_zx_aaddrcright
