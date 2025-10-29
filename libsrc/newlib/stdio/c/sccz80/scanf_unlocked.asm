
; int scanf_unlocked(const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC scanf_unlocked

EXTERN asm_scanf_unlocked

defc scanf_unlocked = asm_scanf_unlocked
