
; void perror(const char *s)

SECTION code_stdio

PUBLIC perror

perror:

   INCLUDE "stdio/z80/asm_perror.asm"
