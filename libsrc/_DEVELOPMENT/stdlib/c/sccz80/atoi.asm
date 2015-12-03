
; int atoi(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC atoi

EXTERN asm_atoi

defc atoi = asm_atoi
