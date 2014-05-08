
; void perror(const char *s)

PUBLIC _perror

_perror:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_perror.asm"
