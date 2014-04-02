
; void perror(const char *s)

XDEF _perror

_perror:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_perror
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_perror.asm"
