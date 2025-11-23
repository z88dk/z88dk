
; void zx_border_fastcall(uchar colour)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_border_fastcall

EXTERN asm_zx_border

defc _zx_border_fastcall = asm_zx_border
