 
; int asprintf (char **ptr, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _asprintf

EXTERN asm_asprintf

defc _asprintf = asm_asprintf
