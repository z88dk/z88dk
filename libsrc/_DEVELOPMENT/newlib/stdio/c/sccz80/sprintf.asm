
; int sprintf(char *s, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC sprintf

EXTERN asm_sprintf

defc sprintf = asm_sprintf
