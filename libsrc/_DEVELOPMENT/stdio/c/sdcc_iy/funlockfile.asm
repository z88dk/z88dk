
; void funlockfile(FILE *file)

XDEF _funlockfile

_funlockfile:

   pop af
   pop ix
   
   push ix
   push af
      
   INCLUDE "stdio/z80/asm_funlockfile.asm"
