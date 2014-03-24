
; int feof(FILE *stream)

XDEF feof

feof:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_feof
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_feof.asm"
