
; void perror(const char *s)

XDEF perror

perror:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_perror.asm"
