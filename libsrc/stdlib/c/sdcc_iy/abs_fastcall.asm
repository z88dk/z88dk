
; int abs_fastcall(int j)

SECTION code_clib
SECTION code_stdlib

PUBLIC _abs_fastcall

EXTERN asm_abs

defc _abs_fastcall = asm_abs
