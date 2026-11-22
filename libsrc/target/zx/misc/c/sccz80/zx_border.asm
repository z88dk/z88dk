
; void zx_border(uchar colour)

SECTION code_clib
SECTION code_arch

PUBLIC zx_border

EXTERN asm_zx_border

defc zx_border = asm_zx_border
