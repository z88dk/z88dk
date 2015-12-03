
; void *zx_saddrpdown(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrpdown

EXTERN asm_zx_saddrpdown

defc zx_saddrpdown = asm_zx_saddrpdown
