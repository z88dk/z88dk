
; void perror(const char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC perror

EXTERN asm_perror

defc perror = asm_perror
