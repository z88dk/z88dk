
; void srand_fastcall(unsigned int seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC _srand_fastcall

EXTERN asm_srand

defc _srand_fastcall = asm_srand
