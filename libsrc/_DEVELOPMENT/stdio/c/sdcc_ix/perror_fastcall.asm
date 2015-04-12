
; void perror_fastcall(const char *s)

SECTION code_stdio

PUBLIC _perror_fastcall

_perror_fastcall:

   push ix
   
   call asm_perror
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_perror.asm"
