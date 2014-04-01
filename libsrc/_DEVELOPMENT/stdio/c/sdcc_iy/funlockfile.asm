
; void funlockfile(FILE *file)

XDEF funlockfile

funlockfile:

   pop af
   pop ix
   
   push ix
   push af
      
   INCLUDE "stdio/z80/asm_funlockfile.asm"
