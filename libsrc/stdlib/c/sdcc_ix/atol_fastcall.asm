
; long atol_fastcall(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC _atol_fastcall

EXTERN asm_atol

defc _atol_fastcall = asm_atol
