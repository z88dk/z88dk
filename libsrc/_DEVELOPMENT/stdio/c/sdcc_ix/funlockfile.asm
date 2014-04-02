
; void funlockfile(FILE *file)

XDEF _funlockfile

_funlockfile:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b

   call asm_funlockfile
   
   pop ix
   ret
      
   INCLUDE "stdio/z80/asm_funlockfile.asm"
