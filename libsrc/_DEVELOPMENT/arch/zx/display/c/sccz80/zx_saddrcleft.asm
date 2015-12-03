
; void *zx_saddrcleft(saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrcleft

EXTERN asm_zx_saddrcleft

defc zx_saddrcleft = asm_zx_saddrcleft
