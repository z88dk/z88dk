 
; int asprintf (char **ptr, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC asprintf

EXTERN asm_asprintf

defc asprintf = asm_asprintf
