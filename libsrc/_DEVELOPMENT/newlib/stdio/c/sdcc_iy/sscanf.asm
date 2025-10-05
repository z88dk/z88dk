
; int sscanf(const char *s, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _sscanf

EXTERN asm_sscanf

defc _sscanf = asm_sscanf
