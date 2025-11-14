
; int fprintf_unlocked(FILE *stream, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC fprintf_unlocked

EXTERN asm_fprintf_unlocked

defc fprintf_unlocked = asm_fprintf_unlocked
