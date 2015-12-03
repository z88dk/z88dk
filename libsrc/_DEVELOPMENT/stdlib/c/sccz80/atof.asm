
; double atof(const char *nptr)

SECTION code_clib
SECTION code_stdlib

PUBLIC atof

EXTERN asm_atof

defc atof = asm_atof
