
; void *zx_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrpup

EXTERN asm_zx_saddrpup

defc zx_saddrpup = asm_zx_saddrpup
