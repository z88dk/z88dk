
; int scanf_unlocked(const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _scanf_unlocked

EXTERN asm_scanf_unlocked

defc _scanf_unlocked = asm_scanf_unlocked
