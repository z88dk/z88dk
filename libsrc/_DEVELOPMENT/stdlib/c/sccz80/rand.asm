
; int rand(void)

SECTION code_stdlib

PUBLIC rand

EXTERN asm_rand

defc rand = asm_rand
