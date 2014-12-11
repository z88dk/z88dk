
; void funlockfile(FILE *file)

SECTION code_stdio

PUBLIC _funlockfile

_funlockfile:

   pop af
   pop ix
   
   push ix
   push af
      
   INCLUDE "stdio/z80/asm_funlockfile.asm"
