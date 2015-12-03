
; long atol(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC atol

EXTERN asm_atol

defc atol = asm_atol
