
; int fgetpos(FILE *stream, fpos_t *pos)

XDEF fgetpos

fgetpos:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fgetpos
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fgetpos.asm"
