
; int ferror(FILE *stream)

XDEF ferror

ferror:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_ferror
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_ferror,asm"
