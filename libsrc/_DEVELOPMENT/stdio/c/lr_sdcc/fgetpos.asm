
; int fgetpos(FILE *stream, fpos_t *pos)

XDEF fgetpos

fgetpos:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fgetpos
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fgetpos.asm"
