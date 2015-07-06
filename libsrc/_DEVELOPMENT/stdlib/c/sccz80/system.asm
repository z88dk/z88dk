
; int system(const char *string)

SECTION code_stdlib

PUBLIC system

EXTERN asm_system

defc system = asm_system
