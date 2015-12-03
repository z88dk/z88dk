
; void srand(unsigned int seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC srand

EXTERN asm_srand

defc srand = asm_srand
