
; int atoi_fastcall(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC _atoi_fastcall

EXTERN asm_atoi

defc _atoi_fastcall = asm_atoi
