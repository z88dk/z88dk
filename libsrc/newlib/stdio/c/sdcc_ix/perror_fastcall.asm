
; void perror_fastcall(const char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _perror_fastcall

EXTERN asm_perror

defc _perror_fastcall = asm_perror
