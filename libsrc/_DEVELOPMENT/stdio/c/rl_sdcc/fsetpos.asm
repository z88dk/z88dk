
; int fsetpos(FILE *stream, const fpos_t *pos)

XDEF fsetpos

fsetpos:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_fsetpos
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fsetpos.asm"
