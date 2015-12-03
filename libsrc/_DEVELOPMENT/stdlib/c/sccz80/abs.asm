
; int abs(int j)

SECTION code_clib
SECTION code_stdlib

PUBLIC abs

EXTERN asm_abs

defc abs = asm_abs
