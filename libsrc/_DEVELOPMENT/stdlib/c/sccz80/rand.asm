
; int rand(void)

SECTION code_clib
SECTION code_stdlib

PUBLIC rand

EXTERN asm_rand

defc rand = asm_rand
