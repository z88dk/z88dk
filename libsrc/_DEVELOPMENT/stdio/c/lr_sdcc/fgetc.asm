
; int fgetc(FILE *stream)

XDEF fgetc

fgetc:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b

   call asm_fgetc
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fgetc.asm"
