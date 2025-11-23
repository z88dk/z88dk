
; int ffsl_fastcall(long i)

SECTION code_clib
SECTION code_string

PUBLIC _ffsl_fastcall

EXTERN asm_ffsl

defc _ffsl_fastcall = asm_ffsl
