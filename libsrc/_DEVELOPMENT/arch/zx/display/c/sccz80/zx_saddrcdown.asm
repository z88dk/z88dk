
; void *zx_saddrcdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrcdown

EXTERN asm_zx_saddrcdown

defc zx_saddrcdown = asm_zx_saddrcdown
