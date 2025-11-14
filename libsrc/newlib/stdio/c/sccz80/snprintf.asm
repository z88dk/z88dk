
; int snprintf(char *s, size_t n, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC snprintf

EXTERN asm_snprintf

defc snprintf = asm_snprintf
