
; int sscanf(const char *s, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC sscanf

EXTERN asm_sscanf

defc sscanf = asm_sscanf
