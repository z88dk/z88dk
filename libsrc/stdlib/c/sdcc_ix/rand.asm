
; int rand(void)

SECTION code_clib
SECTION code_stdlib

PUBLIC _rand

EXTERN asm_rand

defc _rand = asm_rand
